# API

## Create User

```$ curl --location --request POST https://chat-podium.apps.ocp4.keithtenzer.com/api/v4/users --header 'Content-Type: application/json' --data-raw '{"email":"ktenzer@redhat.com","username":"ktenzer","password":"redhat123"}'```

## Get API Token
Now we get the Token. The token is returned in the http header.

```$ curl -i -d '{"login_id":"ktenzer@redhat.com","password":"redhat123"}' https://chat-podium.apps.ocp4.keithtenzer.com/api/v4/users/login```

```
HTTP/1.1 200 OK
Content-Type: application/json
Set-Cookie: MMAUTHTOKEN=pwkydmww9jyz3qrzw8etuuj7bw; Path=/; Expires=Fri, 15 May 2020 12:11:25 GMT; Max-Age=2592000; HttpOnly; Secure
Set-Cookie: MMUSERID=oxi5ygkcytn1dxexd3bcgf5ibr; Path=/; Expires=Fri, 15 May 2020 12:11:25 GMT; Max-Age=2592000; Secure
Set-Cookie: MMCSRF=m9w1ot5tdfrciqc8e5hid9r3ha; Path=/; Expires=Fri, 15 May 2020 12:11:25 GMT; Max-Age=2592000; Secure
Token: pwkydmww9jyz3qrzw8etuuj7bw
X-Request-Id: 8ajh7huynpgi78seqxyo8pusoo
X-Version-Id: 5.11.0.5.11.0.113d244c7d6ee98484bcd685136bfdba.false
Date: Wed, 15 Apr 2020 12:11:26 GMT
Content-Length: 619
Set-Cookie: 01d4e3cb1348223ce020865ff538417e=4b8cf1a7977d968f8985ee434f02211a; path=/; HttpOnly; Secure
```

```
{"id":"oxi5ygkcytn1dxexd3bcgf5ibr","create_at":1586952144114,"update_at":1586952144114,"delete_at":0,"username":"ktenzer","auth_data":"","auth_service":"","email":"ktenzer@redhat.com","nickname":"","first_name":"","last_name":"","position":"","roles":"system_admin system_user","notify_props":{"channel":"true","comments":"never","desktop":"mention","desktop_sound":"true","email":"true","first_name":"false","mention_keys":"ktenzer,@ktenzer","push":"mention","push_status":"away"},"last_password_update":1586952144114,"locale":"en","timezone":{"automaticTimezone":"","manualTimezone":"","useAutomaticTimezone":"true"}}
```

**token: pwkydmww9jyz3qrzw8etuuj7bw**

## Authenticate with user to API
This is a simple API to test access using our token.

```curl -i -H 'Authorization: Bearer pwkydmww9jyz3qrzw8etuuj7bw' https://chat-podium.apps.ocp4.keithtenzer.com/api/v4/users/me```

## Create a team
We will now create a team called myteam. Each team also has an invite link, used to invite users so they can register and join our team.

```$ curl -i --request POST -H 'Authorization: Bearer pwkydmww9jyz3qrzw8etuuj7bw' -d '{"name": "myteam","display_name": "myteam","type": "O"}' https://chat-podium.apps.ocp4.keithtenzer.com/api/v4/teams```

```
{"id":"t4t94zah3fy1bdrz38niwkj69h","create_at":1586953746034,"update_at":1586953746034,"delete_at":0,"display_name":"myteam","name":"myteam","description":"","email":"ktenzer@redhat.com","type":"O","company_name":"","allowed_domains":"","invite_id":"3bd6ey3y6tyw98oksg3cnb6rdw","allow_open_invite":false,"scheme_id":null,"group_constrained":null}
```

**team id: t4t94zah3fy1bdrz38niwkj69h**
**invite id: 3bd6ey3y6tyw98oksg3cnb6rdw**

The teamId is used to create a channel and the inviteId is used in the signup URL to allow new users to join team.

## Create a channel
We will now create a channel called mychannel using the teamId, returned from creating a new team.

```$ curl -i --request POST -H 'Authorization: Bearer pwkydmww9jyz3qrzw8etuuj7bw' -d '{"team_id": "t4t94zah3fy1bdrz38niwkj69h","name": "mychannel","display_name": "mychannel","type": "O"}' https://chat-podium.apps.ocp4.keithtenzer.com/api/v4/channels```

```
{"id":"8h5afsxchfdadrxwnbnqw5tjtr","create_at":1586953961028,"update_at":1586953961028,"delete_at":0,"team_id":"t4t94zah3fy1bdrz38niwkj69h","type":"O","display_name":"mychannel","name":"mychannel","header":"","purpose":"","last_post_at":0,"total_msg_count":0,"extra_update_at":0,"creator_id":"oxi5ygkcytn1dxexd3bcgf5ibr","scheme_id":null,"props":null,"group_constrained":null}
```

## Send invite link to others
Additional users can be added to team and as such have access to public channels by providing the following link.

```https://chat-podium.apps.ocp4.keithtenzer.com/signup_user_complete/?id=3bd6ey3y6tyw98oksg3cnb6rdw```
