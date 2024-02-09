# To check the response code of the URL using Route Planner

import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.DefaultProxyRoutePlanner;

String proxyHost = System.getenv("PROXY_HOST");
int proxyPort = Integer.parseInt(System.getenv("PROXY_PORT"));


HttpHost proxy = new HttpHost(proxyHost, proxyPort);

DefaultProxyRoutePlanner routePlanner = new DefaultProxyRoutePlanner(proxy);

RequestConfig requestConfig = RequestConfig.custom().setConnectTimeout(5000).setSocketTimeout(5000).build();

CloseableHttpClient httpClient = HttpClients.custom().setRoutePlanner(routePlanner).setDefaultRequestConfig(requestConfig).build();				

String hostUrl = System.getenv("HOST_URL");

System.out.println("Host URL: " + hostUrl);
System.out.println("Proxy Host: " + proxyHost);
System.out.println("Proxy Port: " + proxyPort);

HttpGet httpGet = new HttpGet(hostUrl);

HttpResponse response = httpClient.execute(httpGet);

int statusCode = response.getStatusLine().getStatusCode();

System.out.println("Response Code: " + statusCode);				

httpClient.close();
