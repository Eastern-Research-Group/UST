import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import win32com.client

from python.util import config, utils
from python.util.logger_factory import logger


recipient = '' 				# Required. Email address of person receiving the email. Separate multiple addresses with a semicolon.  
cc = None					# Optional. Email address to CC. Separate multiple addresses with a semicolon. 
bcc = None                  # Optional. Email adddress to BCC. Separate multiple addresses with a semicolon. 
subject = None            	# Optional but highly recommended. Subject of email. 
body = None					# Optional but highly recommended. Body of email. 
attachment_path = None		# Optional. String containing the full path of a single attachment, or a list of paths of multiple attachments.  


class Emailer:
	def __init__(self, 
				 recipient,
				 cc=None,
				 bcc=None,
				 subject=None,
				 body=None,
				 attachment_path=None):
		self.recipient = recipient
		self.cc = cc
		self.bcc = bcc
		self.subject = subject
		self.body = body
		if attachment_path:
			self.attachment_path = utils.list_to_string(attachment_path, '; ')
		else:
			self.attachment_path = None 
		self.outlook = None
		self.email_item = None
		

	def get_sender_email(self):
		mapi = self.outlook.GetNameSpace('MAPI')
		return mapi.Accounts[0].SmtpAddress

	def get_sender_first_name(self):
		mapi = self.outlook.GetNameSpace('MAPI')
		return mapi.Accounts[0].DisplayName


	def email(self):
		self.outlook = win32com.client.Dispatch('Outlook.Application')
		self.email_item = self.outlook.CreateItem(0)
		self.email_item.To = self.recipient
		if self.cc:
			self.email_item.CC = self.cc
		if self.bcc:
			self.email_item.BCC = self.bcc
		if self.subject:
			self.email_item.Subject = self.subject
		if self.body:
			self.email_item.Body = self.body
		if self.attachment_path:
			self.email_item.Attachments.Add(self.attachment_path)
		try:
			self.email_item.Send()
		except Exception as e:
			logger.error('Unable to send email to %s: %s', self.recipient, e)
		logger.info('Email sent to %s', self.recipient)


def main(recipient, cc=None, bcc=None, subject=None, body=None, attachment_path=None):
	email = Emailer(recipient=recipient,
					cc=cc,
					bcc=bcc,
					subject=subject,
					body=body,
					attachment_path=attachment_path)
	email.email()


if __name__ == '__main__':   
	main(recipient=recipient, cc=cc, bcc=bcc, subject=subject, body=body, attachment_path=attachment_path)



