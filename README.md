# LSPServiceKit

👩🏻‍🚀 *This project [is still a tad experimental](#development-status). Contributors and pioneers welcome!*

## What?

LSPServiceKit helps Swift clients use [LSPService](https://github.com/codeface-io/LSPService).

## Context

![Context](Documentation/Context_Diagram.jpg)

LSPServiceKit contains a type named `LSPService` that mirrors the [web API of LSPService](https://github.com/codeface-io/LSPService#api). For example, it lets you write `LSPService.api.language("python").connectToLSPServer()` which translates to a websocket connection request on `http://127.0.0.1:8080/lspservice/api/language/python/websocket`.

## Codebase

Here is the internal architecture (composition and essential dependencies) of the codebase:

![](Documentation/architecture.png)

The above image was generated with the [Codeface](https://www.codeface.io) app.

## Development Status

From version/tag 0.1.0 on, LSPServiceKit adheres to [semantic versioning](https://semver.org). So until it has reached 1.0.0, its API may still break frequently, but this will be expressed in version bumps.

LSPServiceKit is already being used in production, but [Codeface](https://codeface.io) is still its primary client. LSPServiceKit will move to version 1.0.0 as soon as its basic practicality and conceptual soundness have been validated by serving multiple real-world clients.