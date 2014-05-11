/* 
Compilation commands shown during video

$ rm -rf build/*
$ javac -d build burp/*.java
$ jar cf seccasts.jar -C build burp 

*/

package burp;

import java.util.List;

public class BurpExtender implements IBurpExtender, IProxyListener
{
	
	private IExtensionHelpers helpers;
	
	@Override
	public void registerExtenderCallbacks(IBurpExtenderCallbacks callbacks)
	{
		helpers = callbacks.getHelpers();
		
		callbacks.registerProxyListener(this);
		
		callbacks.setExtensionName("Seccasts");
	}
	
	@Override
	public void processProxyMessage(boolean messageIsRequest, IInterceptedProxyMessage message)
	{
		if (messageIsRequest) {
			IHttpRequestResponse messageInfo = message.getMessageInfo();
			IRequestInfo rqInfo = helpers.analyzeRequest(messageInfo);
			List headers = rqInfo.getHeaders();
			headers.add("Seccasts: ThisIsATest");
			String request = new String(messageInfo.getRequest());
			String messageBody = request.substring(rqInfo.getBodyOffset());
			byte[] updateMessage = helpers.buildHttpMessage(headers, messageBody.getBytes());
			messageInfo.setRequest(updateMessage);
		}
	}
}

/*

// PRINT HOSTNAME FROM REQUEST TO BURP'S OUTPUT

package burp;

import java.io.PrintWriter;

public class BurpExtender implements IBurpExtender, IHttpListener
{
	private IExtensionHelpers helpers;
	PrintWriter stdout;
	
	@Override
	public void registerExtenderCallbacks(IBurpExtenderCallbacks callbacks)
	{
		stdout = new PrintWriter(callbacks.getStdout(), true);
		
		helpers = callbacks.getHelpers();
		
		callbacks.setExtensionName("Seccasts");
		
		callbacks.registerHttpListener(this);
		
	}
	
	@Override
	public void processHttpMessage(int toolFlag, boolean messageIsRequest, IHttpRequestResponse messageInfo)
	{
		
		if (messageIsRequest){
			IHttpService httpService = messageInfo.getHttpService();
			
			String host = httpService.getHost();
			if (host != null){
				stdout.println(host);
			}
		}
		
		
	}
}

*/

/*

// PRINT "Seccasts Tutorial" VIA BURP'S OUTPUT

package burp;

import java.io.PrintWriter;

public class BurpExtender implements IBurpExtender
{
	@Override
	public void registerExtenderCallbacks(IBurpExtenderCallbacks callbacks)
	{
		callbacks.setExtensionName("Seccasts");
		
		PrintWriter stdout = new PrintWriter(callbacks.getStdout(), true);
		
		stdout.println("Seccasts Tutorial");
		
	}
}

*/