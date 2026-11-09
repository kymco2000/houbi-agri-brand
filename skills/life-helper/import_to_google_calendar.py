import os
import sys
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/calendar.events']

def main():
    if len(sys.argv) < 6:
        print("Usage: python import_to_google_calendar.py <summary> <start_iso> <end_iso> <location> <description>")
        sys.exit(1)

    summary = sys.argv[1]
    start_time = sys.argv[2]
    end_time = sys.argv[3]
    location = sys.argv[4]
    description = sys.argv[5]

    # Resolve paths relative to the script's directory (global storage)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    token_path = os.path.join(script_dir, 'token.json')
    creds_path = os.path.join(script_dir, 'credentials.json')

    creds = None
    if os.path.exists(token_path):
        creds = Credentials.from_authorized_user_file(token_path, SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            try:
                creds.refresh(Request())
            except Exception:
                creds = None
        if not creds:
            if not os.path.exists(creds_path):
                print("ERROR_CREDENTIALS_MISSING")
                sys.exit(1)
            flow = InstalledAppFlow.from_client_secrets_file(creds_path, SCOPES)
            creds = flow.run_local_server(port=0)
        with open(token_path, 'w') as token:
            token.write(creds.to_json())

    try:
        service = build('calendar', 'v3', credentials=creds)

        event = {
            'summary': summary,
            'location': location,
            'description': description,
            'start': {
                'dateTime': start_time,
                'timeZone': 'Asia/Taipei',
            },
            'end': {
                'dateTime': end_time,
                'timeZone': 'Asia/Taipei',
            },
        }

        event = service.events().insert(calendarId='primary', body=event).execute()
        print(f"SUCCESS: {event.get('htmlLink')}")

    except HttpError as error:
        print(f"API_ERROR: {error}")

if __name__ == '__main__':
    main()
