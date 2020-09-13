//
//  CollectionViewWaterfallFlowLayout.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2019/4/24.
//  Copyright © 2019 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

@objc public protocol CollectionViewWaterfallFlowLayoutDelegate: NSObjectProtocol {
    // 定义每个 UICollectionViewCell 的大小
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

public class CollectionViewWaterfallFlowLayout: UICollectionViewFlowLayout {
    // 总列数
    var columnCount: Int = 0

    // 整个高度
    private var maxH: Int?

    // 头部高度
    var headerH: CGFloat = 0

    // 所有item的属性
    fileprivate var layoutAttributesArray = [UICollectionViewLayoutAttributes]()

    weak var delegate: CollectionViewWaterfallFlowLayoutDelegate?

    public override func prepare() {
        // 设置代理
        if delegate == nil {
            delegate = collectionView?.delegate as? CollectionViewWaterfallFlowLayoutDelegate
        }

        if scrollDirection == .vertical {
            let contentWidth: CGFloat = (collectionView?.bounds.size.width)! - sectionInset.left - sectionInset.right
            let marginX = minimumInteritemSpacing
            let itemWidth = (contentWidth - marginX * CGFloat(columnCount - 1)) / CGFloat(columnCount)
            computeAttributesWithItemWidth(CGFloat(itemWidth))

        } else {
            let contentWidth = (collectionView?.bounds.size.height)! - sectionInset.top - sectionInset.bottom
            let marginX = minimumInteritemSpacing
            let itemHeight = (contentWidth - marginX * CGFloat(columnCount - 1)) / CGFloat(columnCount)
            computeAttributesWithItemHeight(CGFloat(itemHeight))
        }
    }

    /// 根据itemWidth计算布局属性
    func computeAttributesWithItemWidth(_ itemWidth: CGFloat) {
        // 定义一个列高数组 记录每一列的总高度
        var columnHeight = [Int](repeating: Int(sectionInset.top + headerH), count: columnCount)
        // 定义一个记录每一列的总item个数的数组
        var columnItemCount = [Int](repeating: 0, count: columnCount)
        var attributesArray = [UICollectionViewLayoutAttributes]()

        // 添加头部属性
        let headerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
        headerAttr.frame = CGRect(x: 0, y: CGFloat(0), width: collectionView!.bounds.size.width, height: headerH)
        attributesArray.append(headerAttr)
        // 给属性数组设置数值
        // self.layoutAttributesArray = attributesArray

        // 遍历数据计算每个item的属性并布局
        var index = 0
        for _ in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            var itemHeight: CGFloat = 200

            if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:sizeForItemAt:)))) ?? false) {
                let size = delegate?.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath) ?? CGSize.zero
                itemHeight = size.height
            }

            // 找出最短列号
            let minHeight: Int = columnHeight.sorted().first!
            let column = columnHeight.firstIndex(of: minHeight)
            // 数据追加在最短列
            columnItemCount[column!] += 1
            let itemX = (itemWidth + minimumInteritemSpacing) * CGFloat(column!) + sectionInset.left
            let itemY = minHeight
            // 等比例缩放 计算item的高度
            let itemH = Int(Double(itemHeight))
            // 设置frame
            attributes.frame = CGRect(x: itemX, y: CGFloat(itemY), width: itemWidth, height: CGFloat(itemH))

            attributesArray.append(attributes)
            // 累加列高
            columnHeight[column!] += itemH + Int(minimumLineSpacing)
            index += 1
        }

        // 找出最高列列号
        let maxHeight: Int = columnHeight.sorted().last!
        let column = columnHeight.firstIndex(of: maxHeight)
        // 根据最高列设置itemSize 使用总高度的平均值
        let columnitem = columnItemCount[column!]
        let itemH = (maxHeight - Int(minimumLineSpacing) * (columnitem + 1)) / (columnitem > 0 ? columnitem : 1)
        itemSize = CGSize(width: itemWidth, height: CGFloat(itemH))
        // 添加尾部属性
        let footerIndexPath: IndexPath = IndexPath(item: 0, section: 0)
        let footerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndexPath)
        footerAttr.frame = CGRect(x: 0, y: CGFloat(maxHeight), width: collectionView!.bounds.size.width, height: 30)
        attributesArray.append(footerAttr)
        // 给属性数组设置数值
        layoutAttributesArray = attributesArray
        maxH = maxHeight + 30
    }

    /// 根据itemHeight计算布局属性
    func computeAttributesWithItemHeight(_ itemWidth: CGFloat) {
        // 定义一个列高数组 记录每一列的总高度
        var columnHeight = [Int](repeating: Int(sectionInset.top + headerH), count: columnCount)
        // 定义一个记录每一列的总item个数的数组
        var columnItemCount = [Int](repeating: 0, count: columnCount)
        var attributesArray = [UICollectionViewLayoutAttributes]()

        // 添加头部属性
        let headerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
        headerAttr.frame = CGRect(x: 0, y: CGFloat(0), width: collectionView!.bounds.size.height, height: headerH)
        attributesArray.append(headerAttr)
        // 给属性数组设置数值
        // self.layoutAttributesArray = attributesArray

        // 遍历数据计算每个item的属性并布局
        var index = 0
        for _ in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            var itemHeight: CGFloat = 200

            if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:sizeForItemAt:)))) ?? false) {
                let size = delegate?.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath) ?? CGSize.zero
                itemHeight = size.width
            }

            // 找出最短列号
            let minHeight: Int = columnHeight.sorted().first!
            let column = columnHeight.firstIndex(of: minHeight)
            // 数据追加在最短列
            columnItemCount[column!] += 1
            let itemX = (itemWidth + minimumInteritemSpacing) * CGFloat(column!) + sectionInset.top
            let itemY = minHeight
            // 等比例缩放 计算item的高度
            let itemH = Int(Double(itemHeight))
            // 设置frame
            attributes.frame = CGRect(x: CGFloat(itemY), y: itemX, width: CGFloat(itemH), height: itemWidth)

            attributesArray.append(attributes)
            // 累加列高
            columnHeight[column!] += itemH + Int(minimumLineSpacing)
            index += 1
        }

        // 找出最高列列号
        let maxHeight: Int = columnHeight.sorted().last!
        let column = columnHeight.firstIndex(of: maxHeight)
        // 根据最高列设置itemSize 使用总高度的平均值
        let columnitem = columnItemCount[column!]
        let itemH = (maxHeight - Int(minimumLineSpacing) * (columnitem + 1)) / (columnitem > 0 ? columnitem : 1)
        itemSize = CGSize(width: CGFloat(itemH), height: itemWidth)
        // 添加尾部属性
        let footerIndexPath: IndexPath = IndexPath(item: 0, section: 0)
        let footerAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndexPath)
        footerAttr.frame = CGRect(x: 0, y: CGFloat(maxHeight), width: collectionView!.bounds.size.height, height: 30)
        attributesArray.append(footerAttr)
        // 给属性数组设置数值
        layoutAttributesArray = attributesArray
        maxH = maxHeight + 30
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributesArray
    }

    /// 重写设置contentSize
    public override var collectionViewContentSize: CGSize {
        get {
            if scrollDirection == .vertical {
                return CGSize(width: (collectionView?.bounds.width)!, height: CGFloat(maxH!))
            } else {
                return CGSize(width: CGFloat(maxH!), height: (collectionView?.bounds.height)!)
            }
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }
}

// @objc protocol CollectionViewWaterfallFlowLayoutDelegate: NSObjectProtocol {
//    // item 的 size (宽高转换：WaterfallFlowVertical根据宽算高，WaterfallFlowHorizontal根据高算宽)
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, heightForItemAt indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, heightForItemAt indexPath: IndexPath, itemHeight: CGFloat) -> CGFloat
//
//    // header/footer 的 size（仅限竖向滑动时使用）
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
//
//    // 定义每个 UICollectionViewCell 的大小
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//
//    // 每个 section 的内边距
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//
//    // 每个 section 下显示的 item 有多少列，返回每个 section 下的 item 的列数
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, columnNumberAt section: Int) -> Int
//
//    // 每个 section 下显示的 item 的最小行间距
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//
//    // 每个 section 下显示的 item 的最小列间距
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//
//    // 本 section 的头部和上个 section 的尾部的间距
//    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallFlowViewLayout, spacingWithPreviousSectionForSectionAt section: Int) -> CGFloat
// }
//
// class CollectionViewWaterfallFlowViewLayout: UICollectionViewLayout {
//    /**
//     *  MARK: - 定义变量
//     **/
//    /// 屏幕的宽高
//    fileprivate let screenWidth = UIScreen.main.bounds.size.width
//    fileprivate let screenHeight = UIScreen.main.bounds.size.height
//
//    public var NavigationHeight: CGFloat = 0
//    public var iPhoneXBottomHeight: CGFloat = 0
//
//    /// collectionView 相关
//    // 记录 collectionView 的 content 可滑动的范围
//    fileprivate var contentScope: CGFloat = 0
//
//    // collectionView 的滑动方向，默认为竖向滑动
//    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
//
//    /// item 相关
//    // item 的行/列数，默认为2行/列
//    public var lineCount: Int = 2
//    public var interitemCount: Int = 2
//
//    // item 之间的间距（行/列），默认间距为10
//    public var lineSpacing: CGFloat = 10
//    public var interitemSpacing: CGFloat = 10
//
//    /// section 相关
//    // section 的内边距，默认上下左右都为10
//    public var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
//
//    // 是否要显示 header/footer，默认不显示
//    public var isShowHeader: Bool = false
//    public var isShowFooter: Bool = false
//
//    // section 的 header/footer 的 size
//    public var headerReferenceSize: CGSize = CGSize.zero
//    public var footerReferenceSize: CGSize = CGSize.zero
//
//    // 当前 section 的 header 与上个 section 的 footer 之间的间距
//    public var spacingWithPreviousSection: CGFloat = 0
//
//    /// 数据处理相关
//    // 存储 item 的所有 layoutAttributes 数组
//    fileprivate lazy var layoutAttributesArray: [UICollectionViewLayoutAttributes] = []
//
//    // 存储横向滑动时 section 每一行的宽度/竖向滑动时 section 每一列的高度
//    fileprivate lazy var lineWidthArray: [CGFloat] = []
//    fileprivate lazy var interitemHeightArray: [CGFloat] = []
//
//    /// 协议代理
//    weak var delegate: CollectionViewWaterfallFlowLayoutDelegate?
//
//    override func prepare() {
//        super.prepare()
//
//        /// 初始化数据
//        // 清空数组中之前保存的所有布局数据
//        layoutAttributesArray.removeAll()
//        contentScope = 0.0
//
//        // 设置代理
//        if delegate == nil {
//            delegate = collectionView?.delegate as? CollectionViewWaterfallFlowLayoutDelegate
//        }
//
//        /// 计算 section 下 item/header/footer 的布局
//        setAllLayoutsForSection()
//    }
//
//    /*
//     *  设置 section 下的 item/header/footer 的布局，并缓存
//     */
//    fileprivate func setAllLayoutsForSection() {
//        // 获取 collectionView 中 section 的个数
//        let getSectionCount = collectionView?.numberOfSections
//        guard let sectionCount = getSectionCount else { return }
//
//        // 遍历 section 下的所有 item/header/footer，并计算出所有 item/header/footer 的布局
//        for i in 0 ..< sectionCount {
//            // 获取 NSIndexPath
////            let indexPath = NSIndexPath(index: i)
//            // 这里获取到的 IndexPath 是个数组，取其内容要用 indexPath.first/indexPath[0]，不能用 indexPath.section，否则会 crash
//
//            let items = collectionView!.numberOfItems(inSection: i)
//
//            for item in 0 ..< items {
//                let indexPath = IndexPath(item: item, section: i)
//
//                // 通过代理调用协议方法，更新一些变量的值
//                invokeProxy(inSection: indexPath.section)
//
//                // 设置 header 的布局，并缓存
//                if isShowHeader {
//                    if let headerAttributesArray = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
//                        layoutAttributesArray.append(headerAttributesArray)
//                    }
//                }
//
//                // 清空数组中之前缓存的高度，留待使用（给下面的 item 计算 y 坐标时使用 -- 必须写在header后面，否则会计算错误）
//                interitemHeightArray.removeAll()
//                lineWidthArray.removeAll()
//                for _ in 0 ..< interitemCount {
//                    // 判断是横向滑动还是竖向滑动
//                    if scrollDirection == .horizontal {
//                        // 缓存 collectionView 的 content 的宽度，为 item 的 x 坐标开始的位置
//                        lineWidthArray.append(contentScope)
//                    } else {
//                        // 缓存 collectionView 的 content 的高度，为 item 的 y 坐标开始的位置
//                        interitemHeightArray.append(contentScope)
//                    }
//                }
//
//                // 设置 item 的布局，并缓存
//                if let itemAttributesArray = layoutAttributesForItem(at: indexPath) {
//                    layoutAttributesArray.append(itemAttributesArray)
//                }
//
//                // 设置 footer 的布局，并缓存
//                if isShowFooter {
//                    if let footerAttributesArray = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath) {
//                        layoutAttributesArray.append(footerAttributesArray)
//                    }
//                }
//            }
//        }
//    }
//
//    /*
//     *  调用代理方法
//     */
//    fileprivate func invokeProxy(inSection section: Int) {
//        /// 返回 section 下 item 的列数
//        if delegate != nil && (delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:columnNumberAt:)))) ?? false {
//            self.interitemCount = (delegate?.collectionView!(self.collectionView!, layout: self, columnNumberAt: section)) ?? interitemCount
//        }
//
//        /// 返回 section 的内边距
//        if delegate != nil && (delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:insetForSectionAt:)))) ?? false {
//            self.sectionInset = (delegate?.collectionView!(self.collectionView!, layout: self, insetForSectionAt: section)) ?? sectionInset
//        }
//
//        /// 返回当前 section 的 header 与上个 section 的 footer 之间的间距
//        if delegate != nil && (delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:spacingWithPreviousSectionForSectionAt:)))) ?? false {
//            self.spacingWithPreviousSection = (delegate?.collectionView!(self.collectionView!, layout: self, spacingWithPreviousSectionForSectionAt: section)) ?? spacingWithPreviousSection
//        }
//
//        /// 返回 section 下的 item 之间的最小行间距
//        if delegate != nil && (delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:minimumLineSpacingForSectionAt:)))) ?? false {
//            self.lineSpacing = (delegate?.collectionView!(self.collectionView!, layout: self, minimumLineSpacingForSectionAt: section)) ?? lineSpacing
//        }
//
//        /// 返回 section 下的 item 之间的最小列间距
//        if delegate != nil && (delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:minimumInteritemSpacingForSectionAt:)))) ?? false {
//            self.interitemSpacing = (delegate?.collectionView!(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section)) ?? interitemSpacing
//        }
//    }
//
//    /// 获取 rect 范围内的所有 item 的布局，并返回计算好的布局结果
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return layoutAttributesArray
//    }
//
//    /// 自定义 item 的布局
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        // 通过 indexPath，创建一个 UICollectionViewLayoutAttributes
//        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//
//        // 判断是竖向布局还是横向布局
//        if scrollDirection == .vertical {
//            // 计算 item 的布局属性
//            verticalLayoutForItem(layoutAttributes, at: indexPath)
//
//            /// 设置 collectionView 的 content 的高度
//            //  获取最大列的高度
//            let (_, maximumInteritemHeight) = maximumInteritemForSection(heightArray: interitemHeightArray)
//            //  判断 collectionView 的 content 的高度 是否比当前计算的最大列的高度小，若小于则更新 collectionView 的 content 的值
//            if contentScope < maximumInteritemHeight {
//                contentScope = maximumInteritemHeight
//                // collectionView的content的高度 + section底部内边距 + iphoneX的底部高度
//                contentScope = contentScope + sectionInset.bottom + iPhoneXBottomHeight
//            }
//
//        } else if scrollDirection == .horizontal {
//            // 计算 item 的布局属性
//            horizontalLayoutForItem(layoutAttributes, at: indexPath)
//
//            /// 设置 collectionView 的 content 的宽度
//            //  获取最大列的高度
//            let (_, maximumLineWidth) = maximumInteritemForSection(heightArray: lineWidthArray) // maximumLineForSection(widthArray: lineWidthArray)
//            //  判断 collectionView 的 content 的宽度 是否比当前计算的最大行的宽度小，若小于则更新 collectionView 的 content 的值
//            if contentScope < maximumLineWidth {
//                contentScope = maximumLineWidth
//                // collectionView的content的宽度 + section右侧内边距
//                contentScope = contentScope + sectionInset.right
//            }
//        }
//
//        return layoutAttributes
//    }
//
//    /*
//     *  竖向布局：计算 item 的布局，并存储每一列的高度
//     *
//     *  @param layoutAttributes: 布局属性
//     *  @param indexPath: 索引
//     */
//    fileprivate func verticalLayoutForItem(_ layoutAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath) {
//        /// 获取 collectionView 的宽度
//        let collectionViewWidth = collectionView?.frame.size.width ?? screenWidth
//
//        /// 计算 item 的 frame
//        //  item 的宽度【item的宽度 = (collectionView的宽度 - 左右内边距 - 列之间的间距 * (列数 - 1)) / 列数】
//        var itemWidth = (collectionViewWidth - sectionInset.left - sectionInset.right - interitemSpacing * CGFloat(interitemCount - 1)) / CGFloat(interitemCount)
//        //  item 的高度【通过代理方法，并根据 item 的宽度计算出 item 的高度】
//        var itemHeight: CGFloat = 0
//        if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:heightForItemAt:itemWidth:)))) ?? false) {
//            itemHeight = delegate?.collectionView!(self.collectionView!, layout: self, heightForItemAt: indexPath, itemWidth: itemWidth) ?? 0
//        }
//        if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:sizeForItemAt:)))) ?? false) {
//            let size = delegate?.collectionView!(self.collectionView!, layout: self, sizeForItemAt: indexPath) ?? CGSize.zero
//            itemWidth = size.width
//            itemHeight = size.height
//        }
//        //  获取高度最小的那一列的列号和高度值
//        let (minimumInteritemNumber, minimumInteritemHeight) = minimumInteritemForSection(heightArray: interitemHeightArray)
//        //  item 的 x 坐标
//        // 【x的坐标 = 左内边距 + 列号 * (item的宽度 + 列之间的间距)】
//        let itemX = sectionInset.left + CGFloat(minimumInteritemNumber) * (itemWidth + interitemSpacing)
//        //  item 的 y 坐标，初始位置为最小列的高度
//        var itemY: CGFloat = minimumInteritemHeight
//        //  如果item的y值不等于上个区域的最高的高度 既不是此区的第一列 要加上此区的每个item的上下间距
//        if indexPath.item < interitemCount {
//            itemY = itemY + sectionInset.top // y坐标值 + section内边距top值（也就是第一行上方是否留白）
//        } else {
//            itemY = itemY + lineSpacing // y坐标值 + 行间距（item与item之间的行间距）
//        }
//
//        //  设置 item 的 attributes 的 frame
//        layoutAttributes.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
//
//        /// 存储所计算列的高度。若已存在，则更新其值；若不存在，则直接赋值（y值 + height）
//        interitemHeightArray[minimumInteritemNumber] = layoutAttributes.frame.maxY
//    }
//
//    /*
//     *  横向布局：计算 item 的布局，并存储每一行的宽度
//     *
//     *  @param layoutAttributes: 布局属性
//     *  @param indexPath: 索引
//     */
//    fileprivate func horizontalLayoutForItem(_ layoutAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath) {
//        /// 获取 collectionView 的高度
//        let collectionViewHeight = collectionView?.frame.size.height ?? (screenHeight - NavigationHeight)
//
//        /// 计算 item 的 frame
//        //  item 的高度【item的高度 = (collectionView的高度 - iphoneX底部的高度 - header的高度 - footer的高度 - 上下内边距 - 行之间的间距 * (行数 - 1)) / 行数】
//        var itemHeight = (collectionViewHeight - iPhoneXBottomHeight - headerReferenceSize.height - footerReferenceSize.height - sectionInset.top - sectionInset.bottom - lineSpacing * CGFloat(lineCount - 1)) / CGFloat(lineCount)
//        //  item 的宽度【通过代理方法，并根据 item 的高度计算出 item 的宽度】
//        var itemWidth: CGFloat = 0
//        if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:heightForItemAt:itemHeight:)))) ?? false) {
//            itemWidth = delegate?.collectionView!(self.collectionView!, layout: self, heightForItemAt: indexPath, itemHeight: itemHeight) ?? 0
//        }
//        if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:sizeForItemAt:)))) ?? false) {
//            let size = delegate?.collectionView!(self.collectionView!, layout: self, sizeForItemAt: indexPath) ?? CGSize.zero
//            itemWidth = size.width
//            itemHeight = size.height
//        }
//        //  获取宽度最小的那一行的行号和宽度值
//        let (minimumLineNumber, minimumLineWidth) = minimumInteritemForSection(heightArray: lineWidthArray) // minimumLineForSection(widthArray: lineWidthArray)
//        //  item 的 y 坐标
//        // 【y的坐标 = 上内边距 + 行号 * (item的高度 + 行之间的间距)】
//        let itemY = headerReferenceSize.height + sectionInset.top + CGFloat(minimumLineNumber) * (itemHeight + lineSpacing)
//        //  item 的 x 坐标，初始位置为最小行的宽度
//        var itemX: CGFloat = minimumLineWidth
//        //  如果item的x值不等于上个区域的最高的高度 既不是此区的第一列 要加上此区的每个item的左右间距
//        if indexPath.item < lineCount {
//            itemX = itemX + sectionInset.left // x坐标值 + section内边距left值（也就是第一列左方是否留白）
//        } else {
//            itemX = itemX + interitemSpacing // x坐标值 + 列间距（item与item之间的列间距）
//        }
//
//        //  设置 item 的 attributes 的 frame
//        layoutAttributes.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
//
//        /// 存储所计算列的高度（若已存在，则更新其值；若不存在，则直接赋值）
//        lineWidthArray[minimumLineNumber] = layoutAttributes.frame.maxX
//    }
//
//    /*
//     *  竖向布局: 计算高度最小的是哪一列                 / 横向布局：计算宽度最小的是哪一行
//     *
//     *  @param  heightArray: 缓存 section 高度的数组  / 缓存 section 宽度的数组
//     *  return  返回最小列的列号和高度值                / 返回最小行的行号和高度值
//     */
//    fileprivate func minimumInteritemForSection(heightArray: [CGFloat]) -> (Int, CGFloat) {
//        if heightArray.count <= 0 {
//            return (0, 0.0)
//        }
//        // 默认第0列的高度最小
//        var minimumInteritemNumber = 0
//        // 从缓存高度数组中取出第一个元素，作为最小的那一列的高度
//        var minimumInteritemHeight = heightArray[0]
//        // 遍历数组，查找出最小的列号和最小列的高度值
//        for i in 1 ..< heightArray.count {
//            let tempMinimumInteritemHeight = heightArray[i]
//            if minimumInteritemHeight > tempMinimumInteritemHeight {
//                minimumInteritemHeight = tempMinimumInteritemHeight
//                minimumInteritemNumber = i
//            }
//        }
//        return (minimumInteritemNumber, minimumInteritemHeight)
//    }
//
//    /*
//     *  竖向布局: 计算高度最大的是哪一列                 / 横向布局：计算宽度最大的是哪一行
//     *
//     *  @param  heightArray: 缓存 section 高度的数组  / 缓存 section 宽度的数组
//     *  return  返回最大列的列号和高度值                / 返回最大行的行号和宽度值
//     */
//    fileprivate func maximumInteritemForSection(heightArray: [CGFloat]) -> (Int, CGFloat) {
//        if heightArray.count <= 0 {
//            return (0, 0.0)
//        }
//        // 默认第0列的高度最小
//        var maximumInteritemNumber = 0
//        // 从缓存高度数组中取出第一个元素，作为最小的那一列的高度
//        var maximumInteritemHeight = heightArray[0]
//        // 遍历数组，查找出最小的列号和最小列的高度值
//        for i in 1 ..< heightArray.count {
//            let tempMaximumInteritemHeight = heightArray[i]
//            if maximumInteritemHeight < tempMaximumInteritemHeight {
//                maximumInteritemHeight = tempMaximumInteritemHeight
//                maximumInteritemNumber = i
//            }
//        }
//        return (maximumInteritemNumber, maximumInteritemHeight)
//    }
//
//    /// 自定义 header/footer 的布局
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        // 通过 elementKind 和 indexPath，创建一个 UICollectionViewLayoutAttributes
//        let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
//        if elementKind == UICollectionView.elementKindSectionHeader {
//            /// 通过代理方法，更新变量 headerReferenceSize 的值
//            if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:referenceSizeForHeaderInSection:)))) ?? false) {
//                self.headerReferenceSize = (delegate?.collectionView!(self.collectionView!, layout: self, referenceSizeForHeaderInSection: (indexPath.first ?? 0))) ?? headerReferenceSize
//            }
//
//            /// 计算 header 的布局
//            layoutSupplementaryView(layoutAttributes, frame: CGRect(x: 0, y: contentScope, width: headerReferenceSize.width, height: headerReferenceSize.height), atTopWhiteSpace: false, atBottomWhiteSpace: false)
//        } else if elementKind == UICollectionView.elementKindSectionFooter {
//            /// 通过代理方法，更新变量 footerReferenceSize 的值
//            if delegate != nil && ((delegate?.responds(to: #selector(CollectionViewWaterfallFlowLayoutDelegate.collectionView(_:layout:referenceSizeForFooterInSection:)))) ?? false) {
//                self.footerReferenceSize = (delegate?.collectionView!(self.collectionView!, layout: self, referenceSizeForFooterInSection: (indexPath.first ?? 0))) ?? footerReferenceSize
//            }
//
//            /// 计算 footer 的布局
//            layoutSupplementaryView(layoutAttributes, frame: CGRect(x: 0, y: contentScope, width: footerReferenceSize.width, height: footerReferenceSize.height), atTopWhiteSpace: false, atBottomWhiteSpace: false)
//        } else {
//            layoutAttributes.frame = CGRect.zero
//        }
//        return layoutAttributes
//    }
//
//    /*
//     *  竖向布局：计算 header/footer 布局，并更新 collectionView 的 content 的滚动范围
//     *
//     *  @param layoutAttributes: 布局属性
//     *  @param frame           : header/footer 的frame
//     *  @param top             : 是否 footer 的上方留白
//     *  @param bottom          : 是否 header 的下方留白
//     */
//    fileprivate func layoutSupplementaryView(_ layoutAttributes: UICollectionViewLayoutAttributes, frame: CGRect, atTopWhiteSpace top: Bool, atBottomWhiteSpace bottom: Bool) {
//        /// 计算 header/footer 的布局
//        //  设置 header/footer 的 frame
//        layoutAttributes.frame = frame
//
//        ///  更新 collectionView 的 content 的值
//        if isShowHeader {
//            contentScope = contentScope + headerReferenceSize.height
//        } else if isShowFooter {
//            contentScope = contentScope + footerReferenceSize.height
//        }
//    }
//
//    /// 设置 collectionVIew 的 content 的宽高（滚动范围）
//    override var collectionViewContentSize: CGSize {
//        _ = super.collectionViewContentSize
//        if scrollDirection == .horizontal && lineWidthArray.count <= 0 {
//            return CGSize.zero
//        } else if scrollDirection == .vertical && interitemHeightArray.count <= 0 {
//            return CGSize.zero
//        }
//
//        // 计算 collectionView 的 content 的 size
//        let getCollectionViewWidth = collectionView?.frame.size.width
//        let getCollectionViewHeight = collectionView?.frame.size.height
//        // 记录竖向滚动情况下 collectionView 固定的宽 / 横向滚动情况下 collectionView 固定的高
//        var collectionViewWidth: CGFloat = 0.0
//        var collectionViewHeight: CGFloat = 0.0
//        if let width = getCollectionViewWidth, let height = getCollectionViewHeight {
//            collectionViewWidth = width
//            collectionViewHeight = height
//        } else {
//            collectionViewWidth = screenWidth
//            collectionViewHeight = screenHeight - NavigationHeight
//        }
//        // 记录竖向滑动下的固定宽和动态高/横向滑动下的动态宽和固定高
//        let tempContentWidth = (scrollDirection == .vertical ? collectionViewWidth : contentScope)
//        let tempContentHeight = (scrollDirection == .vertical ? contentScope : collectionViewHeight)
//        return CGSize(width: tempContentWidth, height: tempContentHeight)
//    }
// }
