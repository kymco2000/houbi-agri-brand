import os
import glob
import re
import subprocess
import sys

def parse_ics(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    events = []
    # Find VEVENT blocks
    vevents = re.findall(r'BEGIN:VEVENT(.*?)END:VEVENT', content, re.DOTALL)
    for vevent in vevents:
        summary = ""
        dtstart = ""
        dtend = ""
        location = ""
        description = ""

        # Parse fields
        for line in vevent.splitlines():
            line = line.strip()
            if line.startswith('SUMMARY:'):
                summary = line[8:]
            elif line.startswith('LOCATION:'):
                location = line[9:]
            elif line.startswith('DESCRIPTION:'):
                description = line[12:].replace('\\n', '\n')
            elif 'DTSTART' in line:
                # Extract time part
                match = re.search(r'(\d{8}T\d{6})', line)
                if match:
                    t_str = match.group(1)
                    dtstart = f"{t_str[:4]}-{t_str[4:6]}-{t_str[6:8]}T{t_str[9:11]}:{t_str[11:13]}:{t_str[13:15]}+08:00"
            elif 'DTEND' in line:
                match = re.search(r'(\d{8}T\d{6})', line)
                if match:
                    t_str = match.group(1)
                    dtend = f"{t_str[:4]}-{t_str[4:6]}-{t_str[6:8]}T{t_str[9:11]}:{t_str[11:13]}:{t_str[13:15]}+08:00"

        events.append({
            'summary': summary,
            'start': dtstart,
            'end': dtend,
            'location': location,
            'description': description
        })
    return events

def main():
    # Scan for .ics files in the CURRENT WORKING DIRECTORY (where the user runs the command)
    cwd = os.getcwd()
    ics_files = glob.glob(os.path.join(cwd, '*.ics'))
    if not ics_files:
        print("No .ics files found in the current directory.")
        return

    print(f"Found {len(ics_files)} .ics files in {cwd}.")

    # Resolve the path to the import_to_google_calendar.py script in the same directory as this script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    importer_script = os.path.join(script_dir, 'import_to_google_calendar.py')
    creds_path = os.path.join(script_dir, 'credentials.json')
    token_path = os.path.join(script_dir, 'token.json')

    if not os.path.exists(creds_path) and not os.path.exists(token_path):
        print(f"[ERROR] Credentials or token not found in global directory: {script_dir}")
        return

    for ics_file in ics_files:
        filename = os.path.basename(ics_file)
        print(f"Parsing {filename}...")
        events = parse_ics(ics_file)
        for ev in events:
            print(f"Importing: {ev['summary']} ({ev['start']} to {ev['end']})")
            # Call import_to_google_calendar.py
            cmd = [
                'python',
                importer_script,
                ev['summary'],
                ev['start'],
                ev['end'],
                ev['location'],
                ev['description']
            ]
            res = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8')
            if "SUCCESS:" in res.stdout:
                print(f"Successfully imported {ev['summary']}!")
            else:
                print(f"Failed to import: {res.stdout.strip()} {res.stderr.strip()}")

if __name__ == '__main__':
    main()
