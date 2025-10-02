namespace go api.health

struct HealthRequest {}

struct HealthResponse {
    1: string message
}

service HealthService {
    HealthResponse Health(1: HealthRequest req) (api.get = "/health")
}
