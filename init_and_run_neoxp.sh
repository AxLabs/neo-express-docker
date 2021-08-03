#!/bin/bash

if [ ! -f "/app/default.neo-express" ]; then
  neoxp create
fi

if [ -f "/app/setup.neoxp-checkpoint" ]; then 
  neoxp checkpoint restore setup.neoxp-checkpoint
fi

if [ -f "/app/setup.batch" ]; then 
  neoxp batch -r setup.batch
fi

neoxp run
