.PHONY: all build run test clean deps docker-up docker-down lint hz-gen

APP_NAME := golang-api-starter
GO_ENV ?= dev
MODULE := github.com/fahmiauliarahman/golang-api-starter

all: deps build

deps:
	go mod tidy
	go mod download

build:
	go build -o bin/$(APP_NAME) ./cmd/server

run:
	GO_ENV=$(GO_ENV) go run ./cmd/server

test:
	go test -v -cover ./...

test-coverage:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

clean:
	rm -rf bin/
	rm -f coverage.out coverage.html

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-logs:
	docker-compose logs -f

lint:
	golangci-lint run ./...

# ============================================
# Hertz Code Generation (hz CLI)
# ============================================

# Install hz CLI tool
hz-install:
	go install github.com/cloudwego/hertz/cmd/hz@latest

# Hz directory configuration
HZ_HANDLER_DIR := biz/handler
HZ_MODEL_DIR := biz/model
HZ_ROUTER_DIR := biz/router
HZ_IDL_PATH := idl

# Initialize new project from IDL (run once for new project)
# Usage: make hz-init 
hz-init:
		hz new -idl $(HZ_IDL_PATH)/health.thrift \
		-mod $(MODULE) \
		--handler_dir $(HZ_HANDLER_DIR) \
		--model_dir $(HZ_MODEL_DIR) \
		--router_dir $(HZ_ROUTER_DIR)

# Update generated code after IDL changes
# Usage: make hz-update IDL=idl/user.thrift
hz-update:
		hz update -idl $(HZ_IDL_PATH) \
		--handler_dir $(HZ_HANDLER_DIR) \
		--model_dir $(HZ_MODEL_DIR) \
		--router_dir $(HZ_ROUTER_DIR)

# Create new IDL file from template
# Usage: make hz-new-idl NAME=order
# Helper to convert to PascalCase (e.g., product -> Product)
PASCAL = $(shell echo $(NAME) | awk '{print toupper(substr($$0,1,1)) tolower(substr($$0,2))}')

hz-new-idl:
	@if [ -z "$(NAME)" ]; then \
		echo "Usage: make hz-new-idl NAME=your_module_name"; \
		exit 1; \
	fi
	@PASCAL_NAME=$$(echo $(NAME) | awk '{print toupper(substr($$0,1,1)) tolower(substr($$0,2))}'); \
	echo "namespace go api.$(NAME)" > $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// Data Structures" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct $${PASCAL_NAME} {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i64 id" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: string name" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    3: i64 created_at" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    4: i64 updated_at" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// Request/Response - Create" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Create$${PASCAL_NAME}Req {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: string name (api.body=\"name\", api.vd=\"len(\$$) > 0\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Create$${PASCAL_NAME}Resp {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i32 code" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: string msg" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    3: optional $${PASCAL_NAME} data" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// Request/Response - Get" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Get$${PASCAL_NAME}Req {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i64 id (api.path=\"id\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Get$${PASCAL_NAME}Resp {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i32 code" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: string msg" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    3: optional $${PASCAL_NAME} data" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// Request/Response - Update" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Update$${PASCAL_NAME}Req {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i64 id (api.path=\"id\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: optional string name (api.body=\"name\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Update$${PASCAL_NAME}Resp {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i32 code" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: string msg" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    3: optional $${PASCAL_NAME} data" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// Request/Response - Delete" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Delete$${PASCAL_NAME}Req {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i64 id (api.path=\"id\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct Delete$${PASCAL_NAME}Resp {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i32 code" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: string msg" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// Request/Response - List" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct List$${PASCAL_NAME}sReq {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: optional string keyword (api.query=\"keyword\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: i64 page (api.query=\"page\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    3: i64 page_size (api.query=\"page_size\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "struct List$${PASCAL_NAME}sResp {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    1: i32 code" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    2: string msg" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    3: list<$${PASCAL_NAME}> data" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    4: i64 total" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// Service Definition" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "// ===========================================================================" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "service $${PASCAL_NAME}Service {" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    Create$${PASCAL_NAME}Resp Create$${PASCAL_NAME}(1: Create$${PASCAL_NAME}Req req) (api.post=\"/api/v1/$(NAME)s\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    Get$${PASCAL_NAME}Resp Get$${PASCAL_NAME}(1: Get$${PASCAL_NAME}Req req) (api.get=\"/api/v1/$(NAME)s/:id\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    Update$${PASCAL_NAME}Resp Update$${PASCAL_NAME}(1: Update$${PASCAL_NAME}Req req) (api.put=\"/api/v1/$(NAME)s/:id\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    Delete$${PASCAL_NAME}Resp Delete$${PASCAL_NAME}(1: Delete$${PASCAL_NAME}Req req) (api.delete=\"/api/v1/$(NAME)s/:id\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "    List$${PASCAL_NAME}sResp List$${PASCAL_NAME}s(1: List$${PASCAL_NAME}sReq req) (api.get=\"/api/v1/$(NAME)s\")" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo "}" >> $(HZ_IDL_PATH)/$(NAME).thrift; \
	echo ""; \
	echo "Created idl/$(NAME).thrift"; \
	echo "Next steps:"; \
	echo "  1. Edit idl/$(NAME).thrift to customize fields"; \
	echo "  2. Run: make hz-update IDL=idl/$(NAME).thrift"

# Generate from all IDL files
hz-gen-all:
	@for f in $(HZ_IDL_PATH)/*.thrift; do \
		echo "Generating from $$f..."; \
		hz update -idl $$f; \
	done

# Show hz help
hz-help:
	hz --help

# ============================================
# Development
# ============================================

fmt:
	go fmt ./...

vet:
	go vet ./...

check: fmt vet lint test

dev: docker-up run

# Show available commands
help:
	@echo "Available commands:"
	@echo "  make deps          - Download dependencies"
	@echo "  make build         - Build binary"
	@echo "  make run           - Run server"
	@echo "  make test          - Run tests"
	@echo "  make docker-up     - Start Docker services"
	@echo "  make docker-down   - Stop Docker services"
	@echo ""
	@echo "Hz (Hertz) Code Generation:"
	@echo "  make hz-install    - Install hz CLI tool"
	@echo "  make hz-init IDL=idl/xxx.thrift    - Init new project from IDL"
	@echo "  make hz-update IDL=idl/xxx.thrift  - Update code from IDL"
	@echo "  make hz-new-idl NAME=order         - Create new IDL template"
	@echo "  make hz-gen-user   - Generate from user.thrift"
	@echo "  make hz-gen-all    - Generate from all IDL files"
