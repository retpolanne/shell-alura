package iam

import "github.com/google/uuid"

type IAMPolicy struct {
	ID       string `json:"id"`
	UserName string `json:"username"`
	Verb     string `json:"verb"`
	Action   string `json:"action"`
}

func createPolicy(username string, verb string, action string) *IAMPolicy {
	return &IAMPolicy{
		ID:       uuid.NewString(),
		UserName: username,
		Verb:     verb,
		Action:   action,
	}
}

func updatePolicy(policy *IAMPolicy, username string, verb string, action string) {
	policy.UserName = username
	policy.Verb = verb
	policy.Action = action
}
