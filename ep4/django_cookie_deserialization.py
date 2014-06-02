from burp import IBurpExtender
from burp import IMessageEditorTabFactory
from burp import IMessageEditorTab
import re
import zlib
import base64
import pickle

class CookieNormalization:
	
	def extract_cookie(self, cookie):
		data = re.search("sessionid=(.*)", cookie)
		cookie_data = data.group(1)
		return cookie_data
	
	def b64_decode(self, s):
		s = str(s)
		number = (-len(s) % 4)
		pad = number * "="
		try:
			return base64.urlsafe_b64decode(s + pad)
		except Exception:
			print Exception

	def normalize_cookie(self, cookie_full):
		try:
			cookie = cookie_full.split(":")[0]
			decoded_data = self.b64_decode(cookie)
			uncompressed_data = zlib.decompress(decoded_data)
			plain_text_cookie = pickle.loads(uncompressed_data)
			return str(plain_text_cookie)
		except Exception:
			print Exception

class BurpExtender(IBurpExtender, IMessageEditorTabFactory):
	
	def	registerExtenderCallbacks(self, callbacks):
    
		# keep a reference to our callbacks object
		self._callbacks = callbacks

		# obtain an extension helpers object
		self._helpers = callbacks.getHelpers()

		# set our extension name
		callbacks.setExtensionName("Deserialize Django Cookies")

		# register ourselves as a message editor tab factory
		callbacks.registerMessageEditorTabFactory(self)

		return
		
	def createNewInstance(self, controller, editable):
		
		 return DeserializeCookie(self, controller, editable)

class DeserializeCookie(IMessageEditorTab):
	
	def __init__(self, extender, controller, editable):
		self._txtInput = extender._callbacks.createTextEditor()
		self._cookie_normalization = CookieNormalization()
		self._extender = extender
	
	def getUiComponent(self):
		return self._txtInput.getComponent()
	
	def getTabCaption(self):
		return "Deserialized Cookie"
		
	def isEnabled(self, content, isRequest):
		if isRequest == True:
			requestInfo = self._extender._helpers.analyzeRequest(content)
			headers = requestInfo.getHeaders();
			self._cookie = ""
			for i, val in enumerate(headers):
				if val.find("Cookie") != -1:
					cookie_str = self._cookie_normalization.extract_cookie(val)
					self._cookie = self._cookie_normalization.normalize_cookie(cookie_str)
		return isRequest and self._cookie
		
	def setMessage(self, content, isRequest):
		if (content is None):
			self._txtInput.setText(None)
			self._txtInput.setEditable(False)
		else:
			self._txtInput.setText(self._cookie)
		return
