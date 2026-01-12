import { UIContext, PromptAction} from '@kit.ArkUI';

@Entry
@Component
export struct RadialMenu {


  private menuItems: Resource[] = [
    $r('sys.symbol.home_button'),
    $r('sys.symbol.AI_search'),
    $r('sys.symbol.music'),
    $r('sys.symbol.house_setting'),
    $r('sys.symbol.game'),
    $r('sys.symbol.clock'),
    $r('sys.symbol.trash'),
    $r('sys.symbol.radio')
  ];

  private menuItemColors: Array<string> = [
    '#934CE4',
    '#7DDA58',
    '#FE9900',
    '#8D6F64',
    '#317FFE',
    '#373266',
    '#E91BAE',
    '#FED831'
  ];

  @State selectedIndex: number = -1;
  @State menuVisible: boolean = false;
  @State rotationAngle: number = 0;
  @State expandProgressList: number[] = this.menuItems.map(() => 0);

  context: UIContext = this.getUIContext();
  prompt: PromptAction = this.context.getPromptAction();

  @Builder
  customDialogBuilder(item: Resource) {
    SymbolGlyph(item)
      .fontColor(['#FFFFFF'])
      .width(70)
      .height(70)
  }

  calculatePosition(index: number): Position {
    const angleStep = 2 * Math.PI / this.menuItems.length;
    const baseAngle = angleStep * index - Math.PI / 2;
    const rotatedAngle = baseAngle + (this.rotationAngle * Math.PI / 180);
    const maxRadius = 70;
    const radius = maxRadius * this.expandProgressList[index];

    const x = Math.cos(rotatedAngle) * radius;
    const y = Math.sin(rotatedAngle) * radius;

    return { x: x, y: y };
  }

  onMenuItemClickHandler(item: Resource, index: number) {
    this.selectedIndex = index;
    this.prompt.openCustomDialog({
      builder: () => this.customDialogBuilder(item),
      width: 70,
      height: 70,
      backgroundColor: this.menuItemColors[index]
    })
  }

  onMenuHandler() {
    if (!this.menuVisible) {
      this.rotationAngle = -30;
      this.menuVisible = true;
      this.menuItems.forEach((_, i) => {
        setTimeout(() => {
          this.expandProgressList[i] = 1;
          this.rotationAngle += 10;
        }, i * 90);
      });
    } else {
      this.menuItems.forEach((_, i) => {
        setTimeout(() => {
          this.expandProgressList[i] = 0;
          this.rotationAngle -= 10;
        }, i * 90);
      })
      setTimeout(() => {
        this.menuVisible = false;
        this.rotationAngle = 0;
      }, this.menuItems.length * 50);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      ForEach(this.menuItems, (item: Resource, index: number) => {
        if (this.menuVisible || this.expandProgressList[index]) {
          ListItem() {
            SymbolGlyph(item)
              .width(45)
              .height(45)
              .fontWeight(FontWeight.Bold)
              .borderRadius(50)
              .fontColor([index === this.selectedIndex ? '#4444FF' : '#FFFFFF'])
              .backgroundColor(index === this.selectedIndex ? '#FFFFFF' : this.menuItemColors[index])
              .opacity(this.expandProgressList[index])
              .position(this.calculatePosition(index))
              .animation({
                duration: 500,
                curve: Curve.EaseOut
              })
              .onClick(() => this.onMenuItemClickHandler(item, index))
          }
        }
      }, (item: Resource, index:number) => item.id.toString())
      Button() {
        SymbolGlyph(this.menuVisible ? $r('sys.symbol.xmark') : $r('sys.symbol.line_3_horizontal'))
          .fontColor([$r('sys.color.white')])
      }
      .width(50)
      .height(50)
      .borderRadius(25)
      .backgroundColor('#333333')
      .onClick(() => this.onMenuHandler())
    }
    .backgroundColor(Color.Black)
    .height('100%')
    .width('100%')
  }
}


