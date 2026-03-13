package main

import (
	"fmt"
	"net/http"
	"runtime"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/retpolanne/shell-alura/modulo-8/mockcloud/pkg/iam"
	"github.com/retpolanne/shell-alura/modulo-8/mockcloud/pkg/instances"
)

var jwtSecret = []byte("dummy-nonprod")

type Claims struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}

func GenerateToken(username string) (string, error) {
	claims := Claims{
		Username: username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString := c.GetHeader("Authorization")
		if tokenString == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Missing Authz token"})
			c.Abort()
			return
		}

		if len(tokenString) > 7 && tokenString[:7] == "Bearer " {
			tokenString = tokenString[7:]
		}

		token, err := jwt.ParseWithClaims(
			tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
				return jwtSecret, nil
			},
		)

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		if claims, ok := token.Claims.(*Claims); ok {
			c.Set("username", claims.Username)
			c.Next()
		} else {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token claims"})
			c.Abort()
		}
	}
}

func handleLogin(c *gin.Context) {
	var credentials struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := c.BindJSON(&credentials); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if credentials.Username == "dummy" && credentials.Password == "dummy123" {
		token, _ := GenerateToken(credentials.Username)
		c.JSON(http.StatusOK, gin.H{"token": token})
	} else {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid Credentials"})
	}
}

// Statefull in-memory instance db
// Key is UUID
var instance_db map[string]*instances.Instance

// Stateful in-memory IAM policies
var policies_db map[string]*iam.IAMPolicy

func canUser(username string) (string, bool) {
	pc, _, _, ok := runtime.Caller(1)
	if !ok {
		return "", false
	}
	verb := runtime.FuncForPC(pc)
	if verb == nil {
		return "", false
	}
	verbName := verb.Name()[5:]
	for _, policy := range policies_db {
		if policy.UserName == username && policy.Verb == verbName {
			if policy.Action == "ALLOW" {
				return verbName, true
			} else {
				return verbName, false
			}
		}
	}
	return verbName, false
}

func createInstance(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	var instance instances.Instance
	if err := c.BindJSON(&instance); err != nil {
		return
	}
	instance.ID = uuid.NewString()
	instance.StartUp()
	instance_db[instance.ID] = &instance
	c.IndentedJSON(http.StatusCreated, instance)
}

func deleteInstance(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	id := c.Param("id")
	delete(instance_db, id)
}

func getInstance(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	id := c.Param("id")
	inMemoryInstance := instance_db[id]
	if inMemoryInstance == nil {
		c.IndentedJSON(http.StatusNotFound, nil)
		return
	}
	c.IndentedJSON(http.StatusOK, inMemoryInstance)
}

func getInstances(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	instances := []instances.Instance{}
	for _, instance_ptr := range instance_db {
		instances = append(instances, *instance_ptr)
	}
	c.IndentedJSON(http.StatusOK, instances)
}

func getInstanceLogs(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	id := c.Param("id")
	inMemoryInstance := instance_db[id]
	if inMemoryInstance == nil {
		c.IndentedJSON(http.StatusNotFound, nil)
		c.Abort()
		return
	}
	logs := inMemoryInstance.RetrieveLogs()
	c.Data(http.StatusAccepted, gin.MIMEJSON, logs)
}

func getInstanceTop(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	id := c.Param("id")
	inMemoryInstance := instance_db[id]
	if inMemoryInstance == nil {
		c.IndentedJSON(http.StatusNotFound, nil)
		c.Abort()
		return
	}
	top := inMemoryInstance.Top()
	c.Data(http.StatusAccepted, gin.MIMEJSON, top)
}

func getPolicies(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	policies := []iam.IAMPolicy{}
	for _, policy_ptr := range policies_db {
		policies = append(policies, *policy_ptr)
	}
	c.IndentedJSON(http.StatusAccepted, policies)
}

func deletePolicy(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	id := c.Param("id")
	delete(policies_db, id)
}

func getPolicy(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	id := c.Param("id")
	inMemoryPolicy := policies_db[id]
	if inMemoryPolicy == nil {
		c.IndentedJSON(http.StatusNotFound, nil)
		c.Abort()
		return
	}
	c.IndentedJSON(http.StatusAccepted, inMemoryPolicy)
}

func createPolicy(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	var policy iam.IAMPolicy
	if err := c.BindJSON(&policy); err != nil {
		return
	}
	policy.ID = uuid.NewString()
	policies_db[policy.ID] = &policy
	c.IndentedJSON(http.StatusCreated, policy)
}

func updatePolicy(c *gin.Context) {
	username := c.MustGet("username").(string)
	if verb, action := canUser(username); !action {
		c.IndentedJSON(http.StatusForbidden,
			gin.H{"error": fmt.Sprintf("user %s cannot do %s", username, verb)},
		)
		c.Abort()
		return
	}
	id := c.Param("id")
	inMemoryPolicy := policies_db[id]
	if inMemoryPolicy == nil {
		c.IndentedJSON(http.StatusNotFound, nil)
		c.Abort()
		return
	}

	c.IndentedJSON(http.StatusAccepted, inMemoryPolicy)
}

func main() {
	policies_db = make(map[string]*iam.IAMPolicy)
	instance_db = make(map[string]*instances.Instance)
	initialPolicy := iam.IAMPolicy{
		ID:       uuid.NewString(),
		UserName: "dummy",
		Verb:     "createPolicy",
		Action:   "ALLOW",
	}
	policies_db[initialPolicy.ID] = &initialPolicy
	router := gin.Default()
	router.POST("/login", handleLogin)
	authorized := router.Group("/")
	authorized.Use(AuthMiddleware())
	authorized.GET("/instance/:id", getInstance)
	authorized.POST("/instance", createInstance)
	authorized.DELETE("/instance/:id", deleteInstance)
	authorized.GET("/instance/:id/logs", getInstanceLogs)
	authorized.GET("/instance/:id/top", getInstanceTop)
	authorized.GET("/instances", getInstances)
	authorized.GET("/policies", getPolicies)
	authorized.GET("/policy/:id", getPolicy)
	authorized.POST("/policies", createPolicy)
	authorized.PATCH("/policies/:id", updatePolicy)
	authorized.DELETE("/policies/:id", deletePolicy)

	router.Run("localhost:8080")
}
