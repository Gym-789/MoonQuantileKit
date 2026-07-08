from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf"
OUT.mkdir(parents=True, exist_ok=True)
PDF_PATH = OUT / "MoonQuantileKit_项目申报书.pdf"

FONT = "Helvetica"
for candidate in [
    Path("C:/Windows/Fonts/msyh.ttc"),
    Path("C:/Windows/Fonts/simhei.ttf"),
    Path("C:/Windows/Fonts/simsun.ttc"),
]:
    if candidate.exists():
        pdfmetrics.registerFont(TTFont("CNFont", str(candidate)))
        FONT = "CNFont"
        break

styles = getSampleStyleSheet()
title = ParagraphStyle(
    "TitleCN",
    parent=styles["Title"],
    fontName=FONT,
    fontSize=19,
    leading=25,
    textColor=colors.HexColor("#17395f"),
    alignment=1,
    spaceAfter=16,
)
section = ParagraphStyle(
    "SectionCN",
    parent=styles["Heading2"],
    fontName=FONT,
    fontSize=12,
    leading=16,
    textColor=colors.HexColor("#17395f"),
    spaceBefore=7,
    spaceAfter=5,
)
body = ParagraphStyle(
    "BodyCN",
    parent=styles["BodyText"],
    fontName=FONT,
    fontSize=9.6,
    leading=14,
    spaceAfter=5,
)
cell = ParagraphStyle("CellCN", parent=body, leading=13, spaceAfter=0)


def p(text, style=body):
    return Paragraph(text, style)


story = [p("MoonQuantileKit 项目申报书", title)]

rows = [
    ("项目名称", "MoonQuantileKit：面向 MoonBit 的流式分位数与延迟摘要基础库"),
    ("参赛者", "郭雨萌"),
    ("联系方式", "13082624476"),
    ("GitHub 仓库", "https://github.com/Gym-789/MoonQuantileKit"),
    ("GitLink 仓库", "https://www.gitlink.org.cn/gym6666/MoonQuantileKit"),
    ("项目方向", "MoonBit 可观测性 / 性能统计 / 流式摘要基础设施"),
    ("是否移植", "否，原创 MoonBit 基础库项目"),
]
table = Table(
    [[p(k, cell), p(v, cell)] for k, v in rows],
    colWidths=[34 * mm, 146 * mm],
)
table.setStyle(
    TableStyle(
        [
            ("FONTNAME", (0, 0), (-1, -1), FONT),
            ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#eaf2fb")),
            ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor("#17395f")),
            ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#b7c8d8")),
            ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ("LEFTPADDING", (0, 0), (-1, -1), 7),
            ("RIGHTPADDING", (0, 0), (-1, -1), 7),
            ("TOPPADDING", (0, 0), (-1, -1), 5),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
        ]
    )
)
story += [table, Spacer(1, 8)]

sections = [
    ("一、项目简介", "MoonQuantileKit 面向 MoonBit 生态提供流式分位数与延迟摘要能力，服务于性能基准、接口监控、日志分析和 CI 质量门禁。项目以整数毫秒和基点分位数表达 P50、P90、P95、P99，避免浮点误差带来的验收不稳定。"),
    ("二、核心功能", "项目已实现 SampleSummary、SummaryConfig、QuantileSnapshot、LatencyBucket、JSON 导出和 CLI 演示，支持有序样本摘要、常见百分位查询、延迟桶统计、快照报告和机器可读输出。"),
    ("三、创新点和价值", "许多项目只关注业务逻辑或图表展示，但缺少可复用的性能摘要底层能力。MoonQuantileKit 把延迟样本转化为稳定、可测试、可导出的分位数结果，可作为监控、压测、竞品对比和自动化验收的基础部件。"),
    ("四、与社区项目差异", "项目不做通用数学矩阵、图表绘制、DataFrame 或 Web 框架，也不采集指标和管理 HTTP 路由。它只专注流式延迟摘要、分位数边界和结果导出，和社区已有数据处理、绘图、限流、哈希、路径规划等方向保持清晰区分。"),
]
for heading, text in sections:
    story += [p(heading, section), p(text)]

story.append(Spacer(1, 12))
story.append(p("五、当前完成情况", section))
story.append(
    p(
        "仓库包含 MoonBit 源码、7 个回归测试、CLI 示例、README、RELATED_WORK、ACCEPTANCE、CHANGELOG、GitHub Actions CI、接口元数据和本申报书。当前可运行 moon check --target all、moon test --target wasm、moon test --target wasm-gc 与 moon run cmd/main。",
    )
)
more = [
    ("六、技术路线", "第一阶段使用确定性精确摘要建立 API 和测试基线；第二阶段在 SummaryConfig 的容量和误差参数基础上扩展 GK/t-digest 风格近似摘要；第三阶段补充滑动窗口、合并摘要和监控系统对接示例。"),
    ("七、验收与质量保障", "CI 按官方安装流程执行 check、test、fmt diff、moon info diff 和 CLI 演示；测试覆盖排序、分位数、快照、桶统计、配置边界和 JSON 输出，保证项目不是空壳。"),
    ("八、后续计划", "继续补充 bounded summary、merge、windowed summary、百分位 SLA 判定、更多延迟分布样例和 benchmark 文档，让项目从教学可用走向工程可用。"),
    ("九、提交说明", "项目围绕公开仓库分步骤提交，每个提交对应一个可解释功能或材料节点，便于评审追踪开发过程。"),
]
for heading, text in more:
    story += [p(heading, section), p(text)]

doc = SimpleDocTemplate(
    str(PDF_PATH),
    pagesize=A4,
    leftMargin=18 * mm,
    rightMargin=18 * mm,
    topMargin=18 * mm,
    bottomMargin=18 * mm,
)
doc.build(story)
print(PDF_PATH)
