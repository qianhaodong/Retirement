@Entry({ routeName: 'messagePage' })
@Component
export struct Index {
  @State message: string = 'Message';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}