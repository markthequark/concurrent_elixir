run:
	iex -S mix

build: format
	mix deps.get && mix compile

format:
	mix format

clean:
	rm -rf deps/ _build/ _output/
