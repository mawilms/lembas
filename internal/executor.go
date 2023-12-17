package internal

type Command int

const (
	Create Command = iota + 1
	Update
	Delete
)

type Instructions struct {
	IsSuccessful int
	Instructions []Instruction
}

func (i *Instructions) execute() {

}

type Instruction struct {
	Command Command
	Path    string
}
