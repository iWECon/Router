# Router

A powerful route for Swift.


## Register

```swift
let userMapping = MappingInfo(group: "user", maps: [

    // 1. none params
    // user/info
    .route("/info", target: UserController.self, remark: "user info")
    
    // 2. required params
    // user/info?{*id}
    .route("/info?{*id}", target: UserController.self, remark: "user info")
    
    // 3. required params (and alias)
    // user/info?{*id/userId/uid}
    .route("/info?{*id/userId/uid}", target: UserController.self, remark: "user info")
    
    // 4. multiple required params (and alias)
    // user/info?{*id/userId}&{*name/nickname}&{*age}
    .route("/info?{*id/userId}&{*name/nickname}&{*age}", target: UserController.self, remark: "user info")
    
    
    // 5. action without UIViewController
    // user/logout
    // 
    // like:
    // > send message action
    // > connect or stop server
    // > login / logout
    .action("/logout", target: UserActions.self, remark: "user logout action")
])

let chatMapping = MappingInfo(group: "chat", maps: [
    // 6> 
    // chat/sendMessage
    .action("/sendMessage", target: ChatActions.self, remark: "send message")
])

Router.load(mappingInfo: userMapping, chatMapping)
```

#### Use

when call `userMapping`

#### 1. `user/info`: 

✅ use `native://user/info`

✅ use `native://user/info?id=10086`


`2> user/info?{*id}`:
 
✅ use `native://user/info?id=10086`

❌ use `native://user/info?uid=10086`, because the `id` is required instead of the `uid` and will console error in xcode terminal

```sh
❌ Missing params: `id`,
Route { native://user/info?uid=10086 }, 
Required: `id` 
```


`3> user/info?{*id/userId/uid}`:

✅ use `native://user/info?id=10086`

✅ use `native://user/info?userId=10086`

✅ use `native://user/info?uid=10086`



`4> user/info?{*id/userId}&{*name/nickname}&{*age}`:


✅ use `native://user/info?id=10086&name=PartyMan&age=18`

✅ use `native://user/info?userId=10086&nickname=PartyMan&age=18`

❌ use `native://user/info?id=10086&name=PartyMan`

```sh
❌ Missing params: `age`,
Route { native://user/info?id=10086&name=PartyMan }, 
Required: `id` or `userId` and
`name` or `nickname` and
`age` 
```

❌ use `native://user/info?id=10086`

```sh
❌ Missing params: `name` or `nickname` and `age`,
Route { native://user/info?id=10086 }, 
Required: `id` or `userId` and
`name` or `nickname` and
`age` 
```
