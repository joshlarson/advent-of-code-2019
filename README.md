# Advent of Code 2019

**TODO: Add description**

## Running

To compile:

```
mix escript.build
```

To run the most recent day:

```
./advent
```

To run any earlier day (day 3, for example):

```
./advent day3
```

To clean up

```
git clean -fdx
```

### Using `entr`

Tests:

```
while true; do sleep 1; ls {lib,test,files}/* | entr -cd bash -c "mix test"; done
```

(If you see errors related to monotonic time decreases, then try this command)
```
while true; do sleep 1; ls {lib,test,files}/* | entr -cd bash -c "elixir --erl '+c false' -S mix test"; done
```

Actual code:

```
while true; do sleep 1; ls lib/* files/* | entr -cd bash -c "mix escript.build; ./advent"; done
```
