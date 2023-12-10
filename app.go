package main

import (
	"context"
	"fmt"
	"github.com/mawilms/lembas/internal"
)

type App struct {
	ctx       context.Context
	datastore internal.DatastoreInterface
}

func NewApp(datastore internal.DatastoreInterface) *App {
	return &App{datastore: datastore}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) Greet(name string) string {
	return fmt.Sprintf("Hello %s, It's show time!", name)
}
