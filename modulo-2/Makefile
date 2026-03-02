run-nginx:
	docker run --name shell-alura-nginx -d -p 8080:80 nginx:1.29.5

fuzz-nginx:
	curl -o /tmp/wordlist.txt https://raw.githubusercontent.com/OctaYus/Wordlists/refs/heads/main/wordlist.txt
	ffuf -w /tmp/wordlist.txt -u http://localhost:8080/FUZZ

nginx-logs:
	docker logs -f shell-alura-nginx
