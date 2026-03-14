// TodoItem.ets - Todo item data model
export default class TodoItem {
  id: string
  title: string
  description: string
  isCompleted: boolean
  createdAt: number
  completedAt?: number

  constructor(title: string, description: string = '') {
    this.id = Date.now().toString() + Math.random().toString(36).substr(2, 9)
    this.title = title
    this.description = description
    this.isCompleted = false
    this.createdAt = Date.now()
  }

  static fromJSON(json: Record<string, Object>): TodoItem {
    const item = new TodoItem('')
    item.id = json['id'] as string
    item.title = json['title'] as string
    item.description = json['description'] as string
    item.isCompleted = json['isCompleted'] as boolean
    item.createdAt = json['createdAt'] as number
    item.completedAt = json['completedAt'] as number
    return item
  }

  toJSON(): Record<string, Object> {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'isCompleted': this.isCompleted,
      'createdAt': this.createdAt,
      'completedAt': this.completedAt
    }
  }

  markCompleted(): void {
    this.isCompleted = true
    this.completedAt = Date.now()
  }

  markUncompleted(): void {
    this.isCompleted = false
    this.completedAt = undefined
  }
}