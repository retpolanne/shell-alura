# Módulo 2 - preparando ambiente

Para esse módulo, vamos usar o Docker para criar um container de NGINX que será utilizado nas aulas. 

Existem muitos métodos de instalar o Docker. Você pode inclusive usar ferramentas compatíveis com Docker, como
o Podman. Irei deixar os links aqui:

- [colima](https://github.com/abiosoft/colima) - esse é o que utilizo no meu macOS

- [podman](https://podman.io/docs/installation#installing-on-mac--windows) - o Podman é outra opção para executar
containers. Porém, será necessário criar um `alias docker="podman"` para que os Makefiles que estão aqui funcionem.

- [Docker Engine](https://docs.docker.com/engine/install/) - o Docker Engine, apesar de ser o mais usado, é o mais datado
por questões de licença. Você não pode usar o Docker for Desktop em computadores corporativos sem uma licença. 

No diretório raíz do repositório, execute `brew bundle` se estiver no Mac para instalar tudo o que é necessário e 
`source source-me.rc` para definir as ferramentas GNU como principais durante a sessão do terminal.

Se estiver no Linux (Debian ou Ubuntu) ou WSL, na raíz do repositório, execute: 

```sh
sudo apt update
sudo apt install -y $(cat packages.txt)
```

Se você estiver no Windows, instale o [Windows Subsystem for Linux](https://learn.microsoft.com/pt-br/windows/wsl/install) 
para poder ter uma máquina virtual Linux instalada.

No Linux, [instale o Golang](https://go.dev/doc/install) e execute:

``` sh
go install github.com/ffuf/ffuf/v2@latest
```

Isso vai instalar uma das ferramentas que vamos usar pra gerar logs no NGINX que será utilizado nas nossas aulas.

Para alguns exercícios, vamos usar exclusivamente o Linux. Para isso, se você estiver no Mac, execute 
`limactl start` e `lima` para usarmos um shell numa máquina virtual Linux.

## Cheatsheet

### Colorindo linhas 

`printf "\e[0;33m%s\e[0;0m\n" *`

Onde: `\e[0;33m` é um escape com a cor amarela ([lista](https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124))
e `\e[0;0m` é um escape sem cor (para parar a cor anterior).

Com o `echo`, usamos:

`echo "\033[0;33mbanana\033[0;0m\n"`

Onde `\033` é um [caractére não printável](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html), `[0;33m` é a cor marrom
e `\033[0;0m` interrompe a coloração.

### Regex para procurar entre dois textos

Eu costumo usar muito esse [regex](https://regex101.com/r/TZOpYe/1) para encontrar textos que estão entre outros 
textos. No `grep`, você precisa usar o parâmetro `-P` para utilizá-lo, pois é um regex perl-like.

`echo "maçã banana maçã" | grep -Po "(?<=maçã ).*(?= maçã)"`

Encontrando todos os links em um repo:

`git grep -Po "https://.*?(?=\))"`

### Usando custom input field separators

Um [IFS](https://en.wikipedia.org/wiki/Input_Field_Separators) é o que separa textos no Bash. Por [padrão](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting-1)
o valor é <space><tab><newline>. Lembrando que esse é o comportamento padrão do bash, e outros shells podem ter comportamentos diferentes.

## Exemplos interessantes

### Usando sort, for, uniq e heredocs para mostrar quantas vezes palavras se repetem

``` sh
for line in $(cat /dev/stdin); do echo "$line" | grep -Po "\w+"; done <<EOF | sort | uniq -c | sort -n | tac
All’s well that ends well.
Nature abhors a vacuum.
Every man has a price.
EOF
```

### Encontrando palavras que se repetem em manpages 

``` sh
find /usr/share/man | head -100 | xargs man 2>/dev/null | grep -o "\w\+" | tr "A-Z" "a-z" | sort | uniq -c | sort -nr | head
  17665 the
   6452 is
   6164 to
   6148 a
   5689 s
   5607 _
   5042 in
   4564 of
   3932 and
   3292 e
```

### Analisando logs de um serviço do systemd

Para analisarmos logs de um serviço do systemd, utilizamos o journalctl.

``` sh
sudo journalctl -xu ssh -o json
```

O `-o cat` pode ser incluído no lugar de `-o json` para mostrar os logs de modo que podemos 
utilizá-los em outros pipes. Também podemos substituir o `-x` por `-f` para seguir o log pelo final.

Também podemos analisar os logs crus, como por exemplo `tail -f /var/log/auth.log`

### Comparando arquivos json sem pretty-print

``` sh
diff <(jq '.' exemplo1.json) <(jq '.' exemplo2.json)
```

### Gerando uma cert chain de SSL

Vendo todos os certs da Alura.

``` sh
openssl s_client -showcerts -connect alura.com.br:443 </dev/null
```

Obtendo o certificado leaf da Alura.

``` sh
openssl s_client -connect alura.com.br:443 </dev/null 2>/dev/null | openssl x509
```

Obtendo o intermediate certificate da Alura.

``` sh
openssl s_client -showcerts -connect alura.com.br:443 </dev/null 2>/dev/null
```

Encontrando certificados raíz.

``` sh
find /etc/ssl/certs/ -name "GTS*"
```

É possível montar toda a chain de certificados da Alura:

``` sh
openssl s_client -showcerts -connect alura.com.br:443 </dev/null 2>/dev/null | grep -Pzo ".*BEGIN CERTIFICATE.*(?s).*?END CERTIFICATE(?-s).*\n"
```

