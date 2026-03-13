package instances

import (
	"fmt"
	"strings"
)

type Instance struct {
	ID       string `json:"id,omitempty"`
	FQDN     string `json:"fqdn"`
	Memory   int    `json:"memory"`
	CPU      int    `json:"cpu"`
	UserData string `json:"user_data,omitempty"`
	Status   string `json:"status,omitempty"`
}

type Log struct {
	Timestamp string `json:"timestamp"`
	Stream    string `json:"stream"`
	Level     string `json:"level"`
	Subsystem string `json:"subsystem"`
	Message   string `json:"message"`
}

func (i *Instance) StartUp() {
	// Caso de erro secreto que iremos explorar em aula
	fmt.Println(i.FQDN)
	if strings.Contains(i.FQDN, "staging") {
		i.Status = "BAD"
		return
	}
	i.Status = "HEALTHY"
}

func (i *Instance) RetrieveLogs() []byte {
	logs := `
	[
		{
			"timestamp": "2026-03-12T14:02:11.102Z",
			"stream": "stdout",
			"level": "info",
			"subsystem": "kernel",
			"message": "Linux version 6.8.5 (builder@ci) #1 SMP PREEMPT_DYNAMIC"
		},
		{
			"timestamp": "2026-03-12T14:02:11.329Z",
			"stream": "stdout",
			"level": "info",
			"subsystem": "memory",
			"message": "Memory: 16324524K/16777216K available"
		},
		{
			"timestamp": "2026-03-12T14:02:11.588Z",
			"stream": "stderr",
			"level": "warn",
			"subsystem": "firmware",
			"message": "firmware: failed to load i915/dg2_dmc_ver2_08.bin (-2)"
		},
		{
			"timestamp": "2026-03-12T14:02:11.812Z",
			"stream": "stdout",
			"level": "info",
			"subsystem": "usb",
			"message": "usb 1-1: new high-speed USB device number 2 using xhci_hcd"
		},
		{
			"timestamp": "2026-03-12T14:02:12.418Z",
			"stream": "stderr",
			"level": "error",
			"subsystem": "ext4",
			"message": "EXT4-fs (sda1): Remounting filesystem read-only"
		}
	]`
	return []byte(logs)
}

func (i *Instance) Top() []byte {
	top := `
	{
		"timestamp": "2026-03-12T14:05:21Z",
		"uptime": "3 days, 04:11",
		"users": 2,
		"load_average": {
			"1m": 0.52,
			"5m": 0.61,
			"15m": 0.73
		},
		"cpu": {
			"user": 8.3,
			"system": 3.1,
			"nice": 0.0,
			"idle": 86.5,
			"iowait": 1.5,
			"steal": 0.0
		},
		"memory": {
			"total_mb": 16384,
			"used_mb": 7342,
			"free_mb": 6021,
			"buffers_cache_mb": 3021
		},
		"processes": [
			{
			"pid": 1,
			"user": "root",
			"cpu_percent": 0.3,
			"mem_percent": 0.2,
			"virt_mb": 168,
			"res_mb": 12,
			"state": "S",
			"command": "systemd"
			},
			{
			"pid": 412,
			"user": "root",
			"cpu_percent": 0.7,
			"mem_percent": 0.4,
			"virt_mb": 220,
			"res_mb": 24,
			"state": "S",
			"command": "journald"
			},
			{
			"pid": 821,
			"user": "node",
			"cpu_percent": 35.2,
			"mem_percent": 8.6,
			"virt_mb": 2048,
			"res_mb": 1410,
			"state": "R",
			"command": "node server.js"
			},
			{
			"pid": 933,
			"user": "postgres",
			"cpu_percent": 12.8,
			"mem_percent": 3.1,
			"virt_mb": 980,
			"res_mb": 508,
			"state": "S",
			"command": "postgres"
			},
			{
			"pid": 1204,
			"user": "anne",
			"cpu_percent": 4.6,
			"mem_percent": 1.2,
			"virt_mb": 410,
			"res_mb": 198,
			"state": "S",
			"command": "python monitor.py"
			}
		]
	}`
	return []byte(top)
}
