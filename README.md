```
fly auth login
fly apps create adguard
cat .env | fly secrets import
fly volumes create app_data --size 1
fly deploy
fly ssh console
```