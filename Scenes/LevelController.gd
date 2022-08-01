extends Node2D

var respawnables = []

func register_respawnable(respawnable):
	respawnables.append(respawnable)

func respawn():
	for respawnable in respawnables:
		respawnable.respawn()
