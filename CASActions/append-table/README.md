# Append a table using Cloud Analytics Services (CAS) REST APIs on SAS Viya

The commands in the append-table.md file come from the SAS Users blog post [Append tables in SAS® Viya® with REST APIs – a treat, no tricks](https://blogs.sas.com/content/sgf/2019/10/28/append-tables-in-sas-viya-with-rest-apis). The series of REST API calls creates a session with the SAS Viya server, loads a table, and then appends the table with additional data.

I used the cURL command to send the requests and I include any needed headers and body text. Further, prior to running the commands you will need to obtain an access token. For more information on authenticating to SAS Viya see the post [Authentication to SAS Viya: a couple of approaches](https://blogs.sas.com/content/sgf/2019/01/25/authentication-to-sas-viya/). I created the ACCESSTOKEN variable to store the value of the acess token. Finally, you will need to replace *https://sasserver* with your SAS Viya server and *\<session-id\>* with the session id created in the first step. 

You can find a Postman collection of the same REST calls in the [append-tables file](../append-tables) in this repository.

More information about SAS REST APIs and open source integration can be found on [developer.sas.com](https://developer.sas.com/home.html).