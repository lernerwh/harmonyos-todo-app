// TodoViewModel.ets - ViewModel for managing todo items
import dataPreferences from '@ohos.data.preferences'
import TodoItem from '../model/TodoItem'

export class TodoViewModel {
  private todoItems: Array<TodoItem> = []
  private preferences: dataPreferences.Preferences
  private readonly STORAGE_NAME = 'todo_preferences'
  private readonly TODOS_KEY = 'todo_items'

  async init(context: Context): Promise<void> {
    try {
      this.preferences = await dataPreferences.getPreferences(context, this.STORAGE_NAME)
      await this.loadTodos()
    } catch (error) {
      console.error('Failed to initialize preferences:', JSON.stringify(error))
    }
  }

  private async loadTodos(): Promise<void> {
    try {
      const todosJson = await this.preferences.get(this.TODOS_KEY, '[]') as string
      const todosArray = JSON.parse(todosJson) as Array<Record<string, Object>>
      this.todoItems = todosArray.map(json => TodoItem.fromJSON(json))
    } catch (error) {
      console.error('Failed to load todos:', JSON.stringify(error))
      this.todoItems = []
    }
  }

  private async saveTodos(): Promise<void> {
    try {
      const todosJson = JSON.stringify(this.todoItems.map(item => item.toJSON()))
      await this.preferences.put(this.TODOS_KEY, todosJson)
      await this.preferences.flush()
    } catch (error) {
      console.error('Failed to save todos:', JSON.stringify(error))
    }
  }

  async addTodo(title: string, description: string = ''): Promise<void> {
    if (!title || title.trim().length === 0) {
      return
    }

    const newTodo = new TodoItem(title.trim(), description.trim())
    this.todoItems.push(newTodo)
    await this.saveTodos()
  }

  async deleteTodo(id: string): Promise<void> {
    const index = this.todoItems.findIndex(item => item.id === id)
    if (index !== -1) {
      this.todoItems.splice(index, 1)
      await this.saveTodos()
    }
  }

  async toggleTodoStatus(id: string): Promise<void> {
    const todo = this.todoItems.find(item => item.id === id)
    if (todo) {
      if (todo.isCompleted) {
        todo.markUncompleted()
      } else {
        todo.markCompleted()
      }
      await this.saveTodos()
    }
  }

  async updateTodo(id: string, title: string, description: string): Promise<void> {
    const todo = this.todoItems.find(item => item.id === id)
    if (todo && title.trim().length > 0) {
      todo.title = title.trim()
      todo.description = description.trim()
      await this.saveTodos()
    }
  }

  getTodoItems(): Array<TodoItem> {
    return [...this.todoItems]
  }

  getCompletedCount(): number {
    return this.todoItems.filter(item => item.isCompleted).length
  }

  getTotalCount(): number {
    return this.todoItems.length
  }

  clearCompleted(): void {
    this.todoItems = this.todoItems.filter(item => !item.isCompleted)
    this.saveTodos()
  }
}

export default new TodoViewModel()