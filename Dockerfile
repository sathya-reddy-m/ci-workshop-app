FROM python:3.6-slim as Build

RUN apt-get update
RUN apt-get install -y curl git

WORKDIR /home/ci-workshop-app

COPY . /home/ci-workshop-app
RUN pip install -r requirements.txt

# RUN /home/ci-workshop-app/bin/train_model.sh
CMD ["/home/ci-workshop-app/bin/start_server.sh"]

FROM Build as Dev

RUN pip install -r /home/ci-workshop-app/requirements-dev.txt
RUN apt-get install -y gnupg && curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

ARG user
RUN useradd ${user:-root} -g root || true
USER ${user:-root}

EXPOSE 8080
CMD ["/home/ci-workshop-app/bin/start_server.sh"]

