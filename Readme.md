bark and chain static bootstrap website

Build and run the site with Docker:

```sh
docker build -t branch-chain-website .
docker run --rm -p 8080:80 branch-chain-website
```

Open http://localhost:8080 to view the website.