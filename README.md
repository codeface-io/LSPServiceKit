# LSPServiceKit

A package that helps Swift clients use [LSPService](https://github.com/flowtoolz/LSPService).

Context:
![Context](Documentation/Context_Diagram.jpg)

LSPServiceKit contains basically one type named `LSPService` that mirrors the [web API of LSPService](https://github.com/flowtoolz/LSPService#api). For example, it lets you write `LSPService.api.language("python").get()` which translates to a `GET` request on `http://127.0.0.1:8080/lspservice/api/language/python`.

