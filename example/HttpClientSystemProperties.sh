# To check the response code of the URL using System Properties

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;

String proxyHost = System.getenv("PROXY_HOST");
String proxyPort = System.getenv("PROXY_PORT");

System.setProperty("http.proxyHost", proxyHost);
System.setProperty("http.proxyPort", proxyPort);
System.setProperty("https.proxyHost", proxyHost);
System.setProperty("https.proxyPort", proxyPort);

String hostUrl = System.getenv("HOST_URL");
System.out.println("Host URL: " + hostUrl);
System.out.println("Proxy Host: " + proxyHost);
System.out.println("Proxy Port: " + proxyPort);

HttpClient httpClient = HttpClients.createSystem();
HttpGet httpGet = new HttpGet(hostUrl);
HttpResponse response = httpClient.execute(httpGet);
int statusCode = response.getStatusLine().getStatusCode();
System.out.println("Response Code: " + statusCode);