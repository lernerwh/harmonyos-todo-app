// TodoPage.ets - 待办事项主页面
import TodoViewModel from '../viewmodel/TodoViewModel'
import TodoItem from '../model/TodoItem'

@Entry
@Component
struct TodoPage {
  @State todoItems: Array<TodoItem> = []
  @State inputText: string = ''
  @State descriptionText: string = ''
  @State showDialog: boolean = false
  @State editingItem: TodoItem | null = null
  @State showCompleted: boolean = true
  private viewModel: TodoViewModel = TodoViewModel

  async aboutToAppear() {
    await this.viewModel.init(getContext(this))
    this.refreshTodoList()
  }

  private refreshTodoList() {
    this.todoItems = this.viewModel.getTodoItems()
  }

  private handleAddTodo() {
    if (this.inputText.trim().length > 0) {
      this.viewModel.addTodo(this.inputText.trim(), this.descriptionText.trim())
      this.inputText = ''
      this.descriptionText = ''
      this.refreshTodoList()
    }
  }

  private handleDeleteTodo(id: string) {
    this.viewModel.deleteTodo(id)
    this.refreshTodoList()
  }

  private handleToggleStatus(id: string) {
    this.viewModel.toggleTodoStatus(id)
    this.refreshTodoList()
  }

  private openEditDialog(item: TodoItem) {
    this.editingItem = item
    this.inputText = item.title
    this.descriptionText = item.description
    this.showDialog = true
  }

  private handleEditTodo() {
    if (this.editingItem && this.inputText.trim().length > 0) {
      this.viewModel.updateTodo(this.editingItem.id, this.inputText.trim(), this.descriptionText.trim())
      this.showDialog = false
      this.editingItem = null
      this.inputText = ''
      this.descriptionText = ''
      this.refreshTodoList()
    }
  }

  private closeDialog() {
    this.showDialog = false
    this.editingItem = null
    this.inputText = ''
    this.descriptionText = ''
  }

  private get displayItems(): Array<TodoItem> {
    if (this.showCompleted) {
      return this.todoItems
    }
    return this.todoItems.filter(item => !item.isCompleted)
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('待办事项')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .padding({ top: 20, bottom: 20 })
      .justifyContent(FlexAlign.Center)

      // 统计信息
      Row() {
        Text(`总计: ${this.viewModel.getTotalCount()}  已完成: ${this.viewModel.getCompletedCount()}`)
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding({ bottom: 10 })
      .justifyContent(FlexAlign.Center)

      // 添加待办事项区域
      Column() {
        TextArea({ placeholder: '输入待办事项标题', text: this.inputText })
          .height(60)
          .borderRadius(8)
          .backgroundColor('#F5F5F5')
          .onChange((value: string) => {
            this.inputText = value
          })

        TextArea({ placeholder: '输入描述（可选）', text: this.descriptionText })
          .height(80)
          .borderRadius(8)
          .backgroundColor('#F5F5F5')
          .margin({ top: 8 })
          .onChange((value: string) => {
            this.descriptionText = value
          })

        Button('添加待办事项')
          .width('100%')
          .height(44)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#2196F3')
          .borderRadius(8)
          .margin({ top: 12 })
          .onClick(() => {
            this.handleAddTodo()
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ bottom: 16 })

      // 筛选按钮
      Row() {
        Button(this.showCompleted ? '显示全部' : '只显示未完成')
          .fontSize(14)
          .backgroundColor('#E3F2FD')
          .fontColor('#2196F3')
          .height(36)
          .onClick(() => {
            this.showCompleted = !this.showCompleted
          })
      }
      .width('100%')
      .margin({ bottom: 12 })
      .justifyContent(FlexAlign.Center)

      // 待办列表
      List() {
        ForEach(this.displayItems, (item: TodoItem, index: number) => {
          ListItem() {
            Row() {
              // 完成状态按钮
              Checkbox({ name: item.id, group: 'todos' })
                .select(item.isCompleted)
                .selectedColor('#4CAF50')
                .width(24)
                .height(24)
                .onChange((value: boolean) => {
                  this.handleToggleStatus(item.id)
                })

              // 待办内容
              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontColor(item.isCompleted ? '#999999' : '#333333')
                  .decoration({
                    type: item.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None
                  })
                  .fontWeight(FontWeight.Medium)

                if (item.description && item.description.length > 0) {
                  Text(item.description)
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ top: 4 })
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }

                // 时间信息
                Text('创建时间: ' + new Date(item.createdAt).toLocaleString())
                  .fontSize(12)
                  .fontColor('#999999')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12, right: 12 })

              // 操作按钮
              Row() {
                Button('编辑')
                  .fontSize(14)
                  .backgroundColor('#FFC107')
                  .width(50)
                  .height(32)
                  .margin({ right: 8 })
                  .onClick(() => {
                    this.openEditDialog(item)
                  })

                Button('删除')
                  .fontSize(14)
                  .backgroundColor('#F44336')
                  .width(50)
                  .height(32)
                  .onClick(() => {
                    this.handleDeleteTodo(item.id)
                  })
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .margin({ bottom: 8 })
          }
        }, (item: TodoItem) => item.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16 })

      // 底部操作栏
      Row() {
        Button('清除已完成')
          .fontSize(14)
          .backgroundColor('#FF9800')
          .height(40)
          .onClick(() => {
            this.viewModel.clearCompleted()
            this.refreshTodoList()
          })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .bindSheet(this.showDialog, this.editDialog(), {
      height: 400,
      dragBar: true,
      onDisappear: () => {
        this.closeDialog()
      }
    })
  }

  @Builder
  editDialog() {
    Column() {
      Text('编辑待办事项')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      TextInput({ placeholder: '标题', text: this.inputText })
        .height(50)
        .borderRadius(8)
        .backgroundColor('#F5F5F5')
        .onChange((value: string) => {
          this.inputText = value
        })

      TextArea({ placeholder: '描述', text: this.descriptionText })
        .height(100)
        .borderRadius(8)
        .backgroundColor('#F5F5F5')
        .margin({ top: 12 })
        .onChange((value: string) => {
          this.descriptionText = value
        })

      Row() {
        Button('取消')
          .layoutWeight(1)
          .height(44)
          .fontSize(16)
          .backgroundColor('#E0E0E0')
          .fontColor('#333333')
          .margin({ right: 8 })
          .onClick(() => {
            this.closeDialog()
          })

        Button('保存')
          .layoutWeight(1)
          .height(44)
          .fontSize(16)
          .backgroundColor('#2196F3')
          .margin({ left: 8 })
          .onClick(() => {
            this.handleEditTodo()
          })
      }
      .width('100%')
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
  }
}