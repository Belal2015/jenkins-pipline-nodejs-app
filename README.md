
# simple-Nodejs-app

A simple NodeJS application with Vite, Docker, and Jenkins CI/CD integration.

---

## 👨‍💻 What I Do as a DevOps Engineer

As a DevOps Engineer, I designed and implemented the CI/CD pipeline for this project to ensure fast, reliable, and automated delivery of application updates. My responsibilities included:

- Containerizing the application using Docker for consistent deployment across environments.
- Creating a Jenkins pipeline to automate building, testing, and deploying the app.
- Integrating DockerHub for image storage and distribution.
- Ensuring best practices for security, scalability, and maintainability.
- Writing clear documentation for developers and operators.


---



## 📑 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Screenshots](#screenshots)
- [Slack Notification Integration](#slack-notification-integration)
- [Getting Started](#getting-started)
- [Docker Integration](#docker-integration)
- [Automating Jenkins Pipeline with Webhooks](#automating-jenkins-pipeline-with-webhooks)
- [Jenkins CI/CD Pipeline](#jenkins-cicd-pipeline)
- [Author](#author)

---

## About the Project

This project demonstrates a full-stack workflow for modern web development, including:

- Fast React development with Vite
- Automated testing and builds
- Containerization with Docker
- Automated CI/CD with Jenkins

---

## Features

- ⚡ React 18 + Vite for lightning-fast development
- 🧪 Unit testing with Vitest
- 🐳 Dockerized for consistent deployments
- 🔄 Jenkins pipeline for CI/CD and DockerHub push

---


## Screenshots

### Jenkins CI/CD Pipeline

![Jenkins Pipeline](src/assets/images/jenkins-pipeline.png)


---

## Slack Notification Integration

This project integrates Slack notifications into the Jenkins CI/CD pipeline. After each build, Jenkins sends a message to a designated Slack channel to inform the team of the build status (success or failure).

**How it works:**

- The Jenkins pipeline uses the `slackSend` step to post messages to Slack.
- Notifications are sent to the `#nodejs-pipline` channel.
- Success and failure messages are color-coded (green for success, red for failure) and include the job name, build number, and a link to the build.


**Slack screenshot:**

The following image shows a sample Slack notification sent by Jenkins:

![Slack Notification](src/assets/images/slack.png)

---

## Getting Started

### Prerequisites

- Node.js (v18+ recommended)
- npm
- Docker (for containerization)

### Local Development

1. **Clone the repository:**
	```sh
	git clone https://github.com/<your-username>/<your-repo-name>.git
	cd <your-repo-name>
	```
2. **Install dependencies:**
	```sh
	npm install
	```
3. **Start the development server:**
	```sh
	npm run dev
	```
4. **Run tests:**
	```sh
	npm test
	```

---

## Docker Integration

This app is fully containerized. The provided `Dockerfile` builds a production-ready image using multi-stage builds:

1. **Build Stage:** Installs dependencies and builds the React app using Node.js.
2. **Production Stage:** Serves the static files using Nginx for optimal performance.

To build and run the app in Docker:
```sh
docker build -t belalmahmoud81/react-app:latest .
docker run -p 80:80 belalmahmoud81/react-app:latest
```

---


## Automating Jenkins Pipeline with Webhooks

To automate your Jenkins pipeline so it runs on every code push, set up a webhook in your Git hosting service (e.g., GitHub, GitLab, Bitbucket):

1. **Go to your repository settings** on your Git hosting platform.
2. **Find the Webhooks section** (usually under "Settings" > "Webhooks").
3. **Add a new webhook** with the following details:
	 - **Payload URL:**
		 - Use your Jenkins server's Git webhook endpoint, typically:
			 `http://<jenkins-server>:8080/github-webhook/` (for GitHub)
			 or
			 `http://<jenkins-server>:8080/gitlab-webhook/` (for GitLab)
	 - **Content type:** `application/json`
	 - **Events:** Choose "Just the push event" (or as needed).
4. **Save the webhook.**

**Jenkins Configuration:**
- In your Jenkins job configuration, ensure "GitHub hook trigger for GITScm polling" (or the equivalent for your platform) is enabled.
- Your Jenkins server must be accessible from your Git hosting service (publicly or via VPN/tunnel).

Once set up, every push to your repository will automatically trigger the Jenkins pipeline defined in your `Jenkinsfile`.

---
## Jenkins CI/CD Pipeline


The Jenkins pipeline automates the following steps:

1. **Install dependencies:** Runs `npm install`.
2. **Run tests:** Executes all unit tests to ensure code quality.
3. **Build app:** Compiles the React app for production.
4. **Docker build:** Builds a Docker image and tags it with the Jenkins build number (`belalmahmoud81/react-app:<build_number>`) and `latest`.
5. **Docker push:** Pushes both tags to DockerHub using secure Jenkins credentials.
6. **Deploy:** Runs the Docker container from the `latest` image tag. (Note: The pipeline can be improved by stopping/removing any previous container before running a new one.)
7. **Cleanup:** Removes local Docker images after deployment to free up disk space.

#### Jenkins Setup

1. Add a Jenkins credential (type: Username with password) with ID `dockerhub` for DockerHub login (matches the Jenkinsfile).
2. Ensure your Jenkins agent has Docker installed and access to DockerHub.
3. Create a pipeline job pointing to this repository. Jenkins will automatically detect the `Jenkinsfile` and run the pipeline on each push.

#### Notes on Deployment and Cleanup

- The deploy stage runs the container with:
	```sh
	docker run -d -p 80:80 belalmahmoud81/react-app:latest
	```
	For production, consider stopping/removing any previous container before running a new one to avoid port conflicts:
	```sh
	docker rm -f react-app || true
	docker run -d --name react-app -p 80:80 belalmahmoud81/react-app:latest
	```
- The cleanup stage removes the images tagged with the build number and `latest` to save disk space:
	```sh
	docker rmi belalmahmoud81/react-app:<build_number> || true
	docker rmi belalmahmoud81/react-app:latest || true
	```

---

## Testing

Run all unit tests with:
```sh
npm test
```

---

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## Author

**Belal Mahmoud** - DevOps Engineer

- **GitHub**: [Belal2015](https://github.com/Belal2015)
- **LinkedIn**: [belal-mahmoud-devops](https://www.linkedin.com/in/belal-mahmoud-devops/)
- **Email**: belalmahmoud8183@gmail.com

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

> **Note:** This top-level README is intentionally high-level; consult each component's documentation for full details.

