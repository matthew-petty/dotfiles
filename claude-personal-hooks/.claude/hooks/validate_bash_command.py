#!/usr/bin/env python3
import json
import re
import sys


def modify_gh_issue_view_command(command: str) -> str:
    """
    Modify gh issue view command to include --json body,comments,title if not present.
    """
    # Check if it's a gh issue view command
    if not re.search(r"\bgh\s+issue\s+view\b", command):
        return command

    # Check if --json flag is already present
    if "--json" in command:
        # Check if it has the required fields
        json_match = re.search(r"--json\s+([^\s]+)", command)
        if json_match:
            fields = json_match.group(1)
            required_fields = {"body", "comments", "title"}
            existing_fields = set(fields.split(","))

            if not required_fields.issubset(existing_fields):
                # Add missing fields
                all_fields = existing_fields.union(required_fields)
                new_fields = ",".join(sorted(all_fields))
                command = command.replace(f"--json {fields}", f"--json {new_fields}")
        return command
    # Add --json flag with required fields
    # Find the right place to insert it (after the issue number/URL)
    # Pattern to match gh issue view <number|url> [other args]
    pattern = r"(gh\s+issue\s+view\s+(?:\d+|https?://[^\s]+))(\s+.*)?$"
    match = re.search(pattern, command)

    if match:
        base_command = match.group(1)
        rest = match.group(2) or ""
        return f"{base_command} --json body,comments,title{rest}"
    # Fallback: just append to the end
    return f"{command} --json body,comments,title"


VALIDATION_RULES = [
    (r"(?<!ast-)\bgrep\b(?!.*\|)", lambda cmd: get_recommendation(cmd)),
    (r"\bcat\s+.*\|\s*grep\b", lambda cmd: get_recommendation(cmd)),
]


def validate_command(command: str) -> list[str]:
    """Validate a bash command and return a list of issues found."""
    issues = []

    # Check for mv commands (suggest git mv)
    if command.strip().startswith("mv "):
        issues.append(
            "Use 'git mv' instead of 'mv' for moving files in git repositories"
        )

    # Check for background commands (ending with &)
    if re.search(r"\s&\s*($|&&)", command):
        issues.append(
            "Commands cannot run in background (&). Remove the & to run synchronously."
        )

    # Check for gh commands with --repo flag
    if re.search(r"\bgh\b", command) and "--repo" in command:
        issues.append(
            "gh commands should not use --repo flag. The repository context is already set."
        )

    # Check for gh commands with text fields that need ANSI-C quoting
    if re.search(r"\bgh\b", command):
        # Look for text field flags that don't use ANSI-C quoting
        # Handle both quoted and unquoted values
        text_field_pattern = (
            r'(--(?:body|title|message)\s+)(["\']?)([^"\']+?)\2(?=\s|$)'
        )

        def convert_to_ansi_c(match):
            flag_part = match.group(1)
            value = match.group(3)
            full_match = match.group(0)

            # Check if it's already using ANSI-C quoting
            if full_match.startswith(flag_part + "$'"):
                return full_match  # Already correct
            return f"{flag_part}$'{value}'"

        # Convert all text fields to ANSI-C quoting
        corrected_command = re.sub(text_field_pattern, convert_to_ansi_c, command)

        # If any changes were made, report the issue
        if corrected_command != command:
            issues.append(
                "gh text fields should use ANSI-C quoting for proper escaping. Example: gh issue create --title $'My title' --body $'My description'. Do NOT fallback to creating an md file."
            )

    # Check for gh issue view commands that need modification
    if re.search(r"\bgh\s+issue\s+view\b", command):
        modified_command = modify_gh_issue_view_command(command)
        if command != modified_command:
            issues.append(
                f"gh issue view commands should include --json body,comments,title. Use: {modified_command}"
            )


def main():
    try:
        # Read input from stdin
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

    # Extract relevant fields
    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})
    command = tool_input.get("command", "")

    # Only validate Bash commands
    if tool_name != "Bash" or not command:
        sys.exit(0)  # Exit successfully if not a Bash command

    # Validate the command
    issues = validate_command(command)

    if issues:
        print("Command validation failed:", file=sys.stderr)
        for message in issues:
            print(f"• {message}", file=sys.stderr)
        sys.exit(2)  # Exit with code 2 to block the command

    # Exit successfully if no issues found
    sys.exit(0)


if __name__ == "__main__":
    main()
