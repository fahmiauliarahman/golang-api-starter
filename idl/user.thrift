namespace go api.user

struct User {
    1: i64    id
    2: string name
    3: string email
    4: string password
    5: i64    created_at
    6: i64    updated_at
}

struct CreateUserReq {
    1: string name (api.body = "name", api.vd = "len($) > 0")
    2: string email (api.body = "email", api.vd = "email($)")
    3: string password (api.body = "password", api.vd = "len($) >= 8")
}

struct CreateUserResp {
    1: i32      code
    2: string   msg
    3: optional User user
}

struct GetUserReq {
    1: i64 id (api.path = "id")
}

struct GetUserResp {
    1: i32      code
    2: string   msg
    3: optional User user
}

struct UpdateUserReq {
    1: i64      id (api.path = "id")
    2: optional string name (api.body = "name")
    3: optional string email (api.body = "email")
    4: optional string password (api.body = "password")
}

struct UpdateUserResp {
    1: i32      code
    2: string   msg
    3: optional User user
}

struct DeleteUserReq {
    1: i64 id (api.path = "id")
}

struct DeleteUserResp {
    1: i32    code
    2: string msg
}

struct ListUsersReq {
    1: optional string keyword (api.query = "keyword")
    2: i64      page (api.query = "page")
    3: i64      page_size (api.query = "page_size")
}

struct ListUsersResp {
    1: i32        code
    2: string     msg
    3: list<User> users
    4: i64        total
}

struct LoginReq {
    1: string email (api.body = "email", api.vd = "email($)")
    2: string password (api.body = "password", api.vd = "len($) >= 8")
}

struct LoginResp {
    1: i32      code
    2: string   msg
    3: optional string token
    4: optional User   user
}

service UserService {
    CreateUserResp CreateUser(1: CreateUserReq req) (api.post = "/api/v1/users")
    GetUserResp GetUser(1: GetUserReq req) (api.get = "/api/v1/users/:id")
    UpdateUserResp UpdateUser(1: UpdateUserReq req) (api.put = "/api/v1/users/:id")
    DeleteUserResp DeleteUser(1: DeleteUserReq req) (api.delete = "/api/v1/users/:id")
    ListUsersResp ListUsers(1: ListUsersReq req) (api.get = "/api/v1/users")
    LoginResp Login(1: LoginReq req) (api.post = "/api/v1/auth/login")
}
