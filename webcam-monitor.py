#!/usr/bin/python
import subprocess
import smtplib
from email.mime.text import MIMEText
from datetime import datetime, timedelta

def check_stream(url):
    try_count = 0
    failure_times = []

    while try_count < 3:
        try:
            # Execute the streamlink command
            result = subprocess.run(
                ["/usr/bin/streamlink", url],
                text=True,  # Get output as text instead of bytes
                capture_output=True
            )
            # Check if streamlink encountered an error
            if "Available streams" not in result.stdout:
                failure_time = datetime.now()
                failure_times.append(failure_time)
                try_count += 1
            else:
#                print("Streamlink executed successfully.")
#                print(result.stdout)
                return True
            
            # Check if 3 failures have occurred within 5 minutes
            if len(failure_times) == 3 and (failure_times[-1] - failure_times[0]) < timedelta(minutes=5):
                send_email(result.stdout)
                break
        except Exception as e:
            print(f"An error occurred while executing the command: {e}")
            try_count += 1

def send_email(error_message):
    # Define email details
    sender = "admin@example.com"
    recipient = "webmaster@example.org"  # set your own credentials
    subject = "Webcam Streaming Failure Notification"
    body = f"The webcam live stream is likely down.\n\nStreamlink encountered the following error:\n\n{error_message}"
    # Create the email
    msg = MIMEText(body)
    msg["From"] = sender
    msg["To"] = recipient
    msg["Subject"] = subject
    try:
        # Send the email using the local SMTP server
        with smtplib.SMTP('localhost') as server:
            server.sendmail(sender, recipient, msg.as_string())
        print("Failure email sent.")
    except Exception as e:
        print(f"Failed to send email: {e}")

if __name__ == "__main__":
    # The URL to check with streamlink
    url = "https://www.youtube.com/channel/UCF1Qy2zp3ae-demo-Ab1234ffcf/live"  # set your own URL
    check_stream(url)
