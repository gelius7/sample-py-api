FROM python:3.7

MAINTAINER gelius "gelius7@gmail.com"

#RUN pip3 install flask
COPY . /app
WORKDIR /app

RUN pip3 install -r requirements.txt

EXPOSE 80

CMD ["app.py"]

#FROM ubuntu:latest
#MAINTAINER gelius "gelius7@gmail.com"
#RUN apt-get update -y
#RUN apt-get install -y python-pip python-dev build-essential
#COPY ./app.py /app
#WORKDIR /app
#RUN pip install -r requirements.txt
#ENTRYPOINT ["python"]
#CMD ["app.py"]