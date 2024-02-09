# To check the response code of the URL using HttpClient Default

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;

String hostUrl = System.getenv("HOST_URL");
System.out.println("Host URL: " + hostUrl);

HttpClient httpClient = HttpClients.createDefault();
HttpGet httpGet = new HttpGet(hostUrl);
HttpResponse response = httpClient.execute(httpGet);
int statusCode = response.getStatusLine().getStatusCode();
System.out.println("Response Code: " + statusCode);