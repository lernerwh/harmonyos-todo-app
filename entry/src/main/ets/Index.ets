// Index.ets - 主页面
@Entry
@Component
struct Index {
  @State message: string = '待办事项应用'
  @State todoItems: Array<string> = []

  build() {
    Column() {
      // 标题栏
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 添加按钮
      Button('添加待办事项')
        .fontSize(16)
        .width(200)
        .height(40)
        .onClick(() => {
          this.todoItems.push('新待办事项')
        })

      // 待办列表
      List() {
        ForEach(this.todoItems, (item: string, index: number) => {
          ListItem() {
            Row() {
              Text(item)
                .fontSize(16)
                .layoutWeight(1)
              Button('删除')
                .fontSize(14)
                .onClick(() => {
                  this.todoItems.splice(index, 1)
                })
            }
            .width('100%')
            .padding(10)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}
