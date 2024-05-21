import UIKit

final class ProgressHUD: UIVisualEffectView {

    var text: String? {
        didSet {
            label.text = text
        }
    }

    let activityIndictor: UIActivityIndicatorView = .init(style: .medium)
    let label: UILabel = .init()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView

    init(text: String) {
        self.text = text
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        text = ""
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(activityIndictor)
        vibrancyView.contentView.addSubview(label)
        activityIndictor.startAnimating()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if let superview = superview {

            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            frame = CGRectMake(
                superview.frame.size.width / 2 - width / 2,
                superview.frame.height / 2 - height / 2,
                width,
                height
            )
            vibrancyView.frame = bounds

            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRectMake(
                5,
                height / 2 - activityIndicatorSize / 2,
                activityIndicatorSize,
                activityIndicatorSize
            )

            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRectMake(
                activityIndicatorSize + 5,
                0,
                width - activityIndicatorSize - 15,
                height
            )
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }

    func show() {
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
