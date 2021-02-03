//
//  ARSPopover.m
//  Popover
//
//  Created by Yaroslav Arsenkin on 27.05.15.
//  Copyright (c) 2015 Iaroslav Arsenkin. All rights reserved.
//

#import "ARSPopover.h"


@interface ARSPopover () <UIPopoverPresentationControllerDelegate>

@end



@implementation ARSPopover

#pragma mark Initialization

- (instancetype)init {
    if (self = [super init]) {
        [self initializePopover];
    }
    
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializePopover];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initializePopover];
    }
    
    return self;
}

- (void)initializePopover {
    self.modalPresentationStyle = UIModalPresentationPopover;
    self.popoverPresentationController.delegate = self;
}

#pragma mark - Actions

- (void)closePopover {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)insertContentIntoPopover:(void (^)(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat presentationArrowHeight))content {
    CGFloat presentationArrowHeight = 12.0;
    CGFloat width = CGRectGetWidth(self.popoverPresentationController.frameOfPresentedViewInContainerView);
    CGFloat height = CGRectGetHeight(self.popoverPresentationController.frameOfPresentedViewInContainerView);
    CGSize popoverSize = CGSizeMake(width, height);
    
    content(self, popoverSize, presentationArrowHeight);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Popover Presentation Controller Delegate

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
    self.popoverPresentationController.sourceView = self.sourceView ? self.sourceView : self.view;
    self.popoverPresentationController.sourceRect = self.sourceRect;
    self.preferredContentSize = self.contentSize;
    
    popoverPresentationController.permittedArrowDirections = self.arrowDirection ? self.arrowDirection : UIPopoverArrowDirectionAny;
    popoverPresentationController.passthroughViews = self.passthroughViews;
    popoverPresentationController.backgroundColor = self.backgroundColor;
    popoverPresentationController.popoverLayoutMargins = self.popoverLayoutMargins;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationController:willRepositionPopoverToRect:inView:)]) {
        [self.delegate popoverPresentationController:popoverPresentationController willRepositionPopoverToRect:rect inView:view];
    }
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationControllerShouldDismissPopover:)]) {
        return [self.delegate popoverPresentationControllerShouldDismissPopover:popoverPresentationController];
    }
    
    return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if ([self.delegate respondsToSelector:@selector(popoverPresentationControllerDidDismissPopover:)]) {
        [self.delegate popoverPresentationControllerDidDismissPopover:popoverPresentationController];
    }
}

#pragma mark - Adaptive Presentation Controller Delegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark Table View

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SVOD_FILTER_TYPE_SIZE;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"];
    
    SVOD_FILTER_TYPE filter = (SVOD_FILTER_TYPE) indexPath.row;
    switch (filter) {
        case tagSVODFilterDefault:
            cell.textLabel.text = NSLocalizedString(@"item_details_filters_default_text", comment:"");
            break;
        case tagSVODFilterDateReleased:
            cell.textLabel.text = NSLocalizedString(@"item_details_filters_date_released_text", comment:"");
            break;
        case tagSVODFilterAlphabeticalAZ:
            cell.textLabel.text = NSLocalizedString(@"item_details_filters_alphabetical_az_text", comment:"");
            break;
        default:
            break;
    }
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
    
    if (filter == self.currentFilter) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate updateSelectedFilter:(SVOD_FILTER_TYPE) indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
