main:
	brew install sonar-scanner && chmod +x ./run.sh && docker compose up -d
start:
	docker compose up -d --no-recreate && sh run.sh