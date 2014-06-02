from burp import IBurpExtender
from java.io import PrintWriter

class BurpExtender(IBurpExtender):
	
	def registerExtenderCallbacks(self, callbacks):
		
		callbacks.setExtensionName("Seccasts Tutorial - Jython")
		
		stdout = PrintWriter(callbacks.getStdout(), True)
		
		stdout.println("Hello from Seccasts!")
		
		return