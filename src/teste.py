import faust

class Greeting(faust.Record):
    from_name: str
    to_name: str

app = faust.App('hello-app', broker='kafka://kafka', topic_partitions=1)
topic = app.topic('hello-topic', value_type=Greeting, internal=True, partitions=1)
counts = app.Table('name_counts', default=int, partitions=1)

@app.agent(topic)
async def hello(greetings):
    await topic.declare()

    async for greeting in greetings:
        print(f'Hello from {greeting.from_name} to {greeting.to_name}')

        counts[greeting.from_name] += 1
        counts[greeting.to_name] += 1
        print(dict(counts))
        print(type(counts))


if __name__ == '__main__':
    app.main()
