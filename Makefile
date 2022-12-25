main:
	brew install sonar-scanner && chmod +x ./run.sh
start:
	docker compose up -d --no-recreate && sh run.sh