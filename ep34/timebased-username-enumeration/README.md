This script is largely a PoC for demonstrating the practicality of time-based username enumeration in certain circumstances. 

To determine whether a site is vulnerable we require a valid username. Leveraging the known valid username we send a specified number of requests to the desired URI, measuring the response time and computing the average. We do the same for a known invalid username. We then compare the average response times. If there's a distinct difference in the response times (given an acceptable margin), the site may be vulnerable.

Leveraging a similar technique, we can attempt to exploit the vulnerability. 

# Usage
```
ruby enumerate.rb -x "http://google.com" -d "sessions[username]=PARAM&sessions[password]=a" --validuser "realemail@example.com" -c 10 --method POST --margin 100 --input-file "/Users/John/dictionary-file"
```


```
Usage: enumerate.rb [options]
    -u, --validuser [USER]           Valid username for comparison
    -f, --input-file [FILEPATH]      Path to dictionary filecontaining usernames
    -c, --request-count [COUNT]      Number of requests to send beforemaking a decision. Defaults to 10
    -d, --query-data [DATA]          HTTP data to send
    -x, --uri [URI]                  Request URI
        --method [METHOD]            HTTP request method
        --margin [MARGIN]            Time margin for determining successful exploitation (Defaults to 50ms)
        --cookies [COOKIES]          HTTP Cookies to use in request
        --proxy-address [PADDR]      Proxy Address
        --proxy-port [PPORT]         Proxy Port
```

# Todo
* **Default Options**: Default options currently aren't available.

# Contact
Feel free to contact me with any questions, john.m.poulin@gmail.com
