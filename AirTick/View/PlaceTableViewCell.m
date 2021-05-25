//
//  PlaceTableViewCell.m
//  AirTick
//
//  Created by Grigory Stolyarov on 18.05.2021.
//

#import "PlaceTableViewCell.h"

@implementation PlaceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGRect cellFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    
    if (self) {
        _labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, cellFrame.size.width - 60, 24.0)];
        _labelName.textAlignment = NSTextAlignmentLeft;
        _labelName.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
        [self.contentView addSubview: _labelName];
        
        _labelCode = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, cellFrame.size.width - 60, 24.0)];
        _labelCode.textAlignment = NSTextAlignmentLeft;
        _labelCode.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        [self.contentView addSubview: _labelCode];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellFrame.size.width - 40, 15, 30, 30)];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.image = [UIImage systemImageNamed:@"arrow.right.circle"];
        [self.contentView addSubview: _arrowImageView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
