FROM python:3.7

MAINTAINER gelius "gelius7@gmail.com"

COPY . /app
WORKDIR /app

RUN pip3 install -r requirements.txt

EXPOSE 80

ENTRYPOINT [ "python3" ]

CMD ["app.py"]
