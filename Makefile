.PHONY: all vagrant clean

all: vagrant

vagrant:
	vagrant up --no-destroy-on-error --no-color | tee ./vagrantup.log

clean:
	vagrant destroy -f --no-color
	rm -rf .vagrant vagrantup.log .swarm
