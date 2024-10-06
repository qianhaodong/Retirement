import { login, ResManager, userStore } from '@hm/basic/Index';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { Log } from '@abner/log';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct LoginPage {
  @State
  isLoading: boolean = false;

  // 登录
  handleLogin() {
    this.isLoading = true;

    // 创建授权请求，并设置参数
    let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    authRequest.scopes = ['phone'];
    // 获取code需传如下permission
    authRequest.permissions = ['serviceauthcode'];
    // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    authRequest.forceAuthorization = true;
    // 用于防跨站点请求伪造，非空字符串即可
    authRequest.state = util.generateRandomUUID();

    // TODO - 权限申请暂未通过
    // 执行请求
    /*try {
      let controller = new authentication.AuthenticationController(getContext(this));
      controller.executeRequest(authRequest, async (err, data) => {
        if (err) {
          Log.error('auth fail,error: %{public}s' + JSON.stringify(err))
          this.isLoading = false;
          return;
        }
        let authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
        let state = authorizationWithHuaweiIDResponse.state;
        if (state != undefined && authRequest.state != state) {
          Log.error('auth fail,The state is different: %{public}s' + JSON.stringify(authorizationWithHuaweiIDResponse));
          this.isLoading = false;
          return;
        }
        Log.info('auth success: %{public}s' + JSON.stringify(authorizationWithHuaweiIDResponse));
        let authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
        let code = authorizationWithHuaweiIDCredential.authorizationCode!;
        Log.info('code: ' + code);
        // 开发者处理code
        // 登录，获取 token
        const token = await login({ clientId: '112212137', clientSecret: '0eec643a5aa3848492fbdee14b632231e0763d93535fe01700ecbf7781fb6c5f', code });
        Log.info('token: ' + token);

        // 存储 token
        await userStore.setUser({ token });

        // 跳转页面
        router.replaceUrl({
          url: 'pages/Index'
        });

        this.isLoading = false;
      });
    } catch (error) {
      this.isLoading = false;
      Log.error('auth failed: %{public}s' + JSON.stringify(error));
    }*/

    // 模拟请求
    setTimeout(async () => {
      const token = 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw';

      // 存储 token
      await userStore.setUser({ token });

      // 跳转页面
      router.replaceUrl({
        url: 'pages/Index'
      });

      this.isLoading = false;
    }, 1000);
  }

  build() {
    Column() {
      Column() {
        Image($r("app.media.pic_login_icon"))
          .width(124)
          .height(76)
          .margin({ bottom: 20 })
        Text() {
          Span('翼康养老')
            .fontColor('#000')
            .fontSize(24)
            .fontWeight(700)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#fff')

      Button({ stateEffect: true }) {
        if (!this.isLoading) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('华为登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }
        } else {
          Row() {
            LoadingProgress()
              .width(24)
              .margin({ right: 5 })
              .color('#fff')
            Text('登录中...')
              .fontColor(ResManager.EC_MID_WHITE)
              .fontSize(ResManager.EC_NORMAL_FS)
          }
        }
      }
      .margin({ top: 150 })
      .width(250)
      .height(40)
      .backgroundColor(ResManager.EC_MAIN_COLOR)
      .onClick(() => {
        this.handleLogin();
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}