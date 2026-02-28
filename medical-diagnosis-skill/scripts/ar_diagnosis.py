#!/usr/bin/env python3
"""
过敏性鼻炎诊断与治疗决策算法
Allergic Rhinitis Diagnosis and Treatment Algorithm
"""

from enum import Enum
from dataclasses import dataclass
from typing import List, Dict, Optional


class Severity(Enum):
    """严重程度"""
    MILD = "轻度"
    MODERATE = "中度"
    SEVERE = "重度"


class Pattern(Enum):
    """病程分型"""
    INTERMITTENT = "间歇性"
    PERSISTENT = "持续性"


@dataclass
class Symptoms:
    """症状评分"""
    sneeze: int  # 打喷嚏 (0-3)
    rhinorrhea: int  # 流涕 (0-3)
    nasal_itch: int  # 鼻痒 (0-3)
    nasal_congestion: int  # 鼻塞 (0-3)

    def validate(self):
        """验证评分范围"""
        for field in [self.sneeze, self.rhinorrhea, self.nasal_itch, self.nasal_congestion]:
            if not 0 <= field <= 3:
                raise ValueError(f"症状评分必须在0-3之间")

    def calculate_tnss(self) -> int:
        """计算TNSS总分"""
        return self.sneeze + self.rhinorrhea + self.nasal_itch + self.nasal_congestion


@dataclass
class DiseaseCourse:
    """病程信息"""
    days_per_week: int  # 每周发作天数
    duration_weeks: int  # 持续周数


@dataclass
class PatientInfo:
    """患者信息"""
    age: int
    is_pregnant: bool = False
    is_lactating: bool = False
    has_asthma: bool = False
    has_glaucoma: bool = False
    has_bph: bool = False  # 前列腺增生
    has_hypertension: bool = False
    has_heart_disease: bool = False
    has_liver_disease: bool = False
    has_kidney_disease: bool = False
    creatinine_clearance: Optional[float] = None  # 肌酐清除率
    current_medications: List[str] = None
    drug_allergies: List[str] = None
    recent_alcohol: bool = False

    def __post_init__(self):
        if self.current_medications is None:
            self.current_medications = []
        if self.drug_allergies is None:
            self.drug_allergies = []


class ARDiagnostic:
    """过敏性鼻炎诊断类"""

    @staticmethod
    def classify_severity(tnss_score: int) -> Severity:
        """
        根据TNSS评分判断严重程度
        
        Args:
            tnss_score: TNSS总分 (0-12)
        
        Returns:
            Severity枚举
        """
        if tnss_score <= 4:
            return Severity.MILD
        elif tnss_score <= 8:
            return Severity.MODERATE
        else:
            return Severity.SEVERE

    @staticmethod
    def classify_pattern(disease_course: DiseaseCourse) -> Pattern:
        """
        根据病程判断分型
        
        Args:
            disease_course: 病程信息
        
        Returns:
            Pattern枚举
        """
        if (disease_course.days_per_week < 4 or 
            disease_course.duration_weeks < 4):
            return Pattern.INTERMITTENT
        else:
            return Pattern.PERSISTENT

    @staticmethod
    def differential_diagnosis(symptoms_dict: Dict) -> List[str]:
        """
        鉴别诊断
        
        Args:
            symptoms_dict: 症状字典
        
        Returns:
            可能的其他诊断列表
        """
        alerts = []
        
        # 感冒
        if (symptoms_dict.get('has_fever') or 
            symptoms_dict.get('sore_throat') or
            symptoms_dict.get('yellow_discharge')):
            alerts.append("⚠️ 症状提示可能为感冒，病程短（7-10天），可能伴咽痛、发热、黄涕")
        
        # 鼻窦炎
        if (symptoms_dict.get('purulent_discharge') or
            symptoms_dict.get('facial_pain') or
            symptoms_dict.get('loss_of_smell')):
            alerts.append("⚠️ 症状提示可能为鼻窦炎，黄/绿脓涕、面颊痛、嗅觉下降")
        
        # 血管运动性鼻炎
        if (symptoms_dict.get('cold_air_trigger') and
            not symptoms_dict.get('significant_itch')):
            alerts.append("⚠️ 可能为血管运动性鼻炎，诱因以冷空气、气味、体位变化为主，无明显鼻痒")
        
        return alerts


class TreatmentPlanner:
    """治疗方案规划类"""

    @staticmethod
    def generate_treatment_plan(
        severity: Severity,
        pattern: Pattern,
        patient: PatientInfo,
        symptoms: Symptoms
    ) -> Dict:
        """
        生成个性化治疗方案
        
        Args:
            severity: 严重程度
            pattern: 病程分型
            patient: 患者信息
            symptoms: 症状评分
        
        Returns:
            治疗方案字典
        """
        plan = {
            "primary_medications": [],
            "adjunct_therapies": [],
            "contraindications": [],
            "warnings": [],
            "special_instructions": []
        }

        # 特殊人群处理
        if patient.is_pregnant:
            return TreatmentPlanner._pregnancy_plan(severity, patient)
        
        if patient.is_lactating:
            return TreatmentPlanner._lactation_plan(severity, patient)
        
        if patient.age < 2:
            plan["primary_medications"].append({
                "name": "生理盐水鼻腔冲洗",
                "dosage": "每天2-3次",
                "note": "婴幼儿唯一安全选择"
            })
            plan["special_instructions"].append("2岁以下婴幼儿建议线下儿科就诊")
            return plan

        # 青光眼禁忌
        if patient.has_glaucoma:
            plan["contraindications"].extend([
                "第一代抗组胺药（扑尔敏等）",
                "鼻用减充血剂（羟甲唑啉等）"
            ])
        
        # 前列腺增生禁忌
        if patient.has_bph:
            plan["contraindications"].extend([
                "第一代抗组胺药",
                "伪麻黄碱"
            ])

        # 根据严重程度和分型制定方案
        if severity == Severity.MILD and pattern == Pattern.INTERMITTENT:
            # 轻度间歇性
            plan["primary_medications"].append({
                "name": "氯雷他定片 或 鼻用抗组胺药",
                "dosage": "氯雷他定 10mg 每天1次，按需使用",
                "duration": "症状发作时使用"
            })
        
        elif severity == Severity.MILD and pattern == Pattern.PERSISTENT:
            # 轻度持续性
            plan["primary_medications"].extend([
                {
                    "name": "鼻用糖皮质激素（首选）",
                    "options": ["糠酸莫米松", "丙酸氟替卡松", "布地奈德"],
                    "dosage": "每天1次，每侧鼻孔2喷",
                    "duration": "至少2-4周"
                },
                {
                    "name": "口服抗组胺药（辅助）",
                    "options": ["氯雷他定", "地氯雷他定"],
                    "dosage": "按需使用，控制鼻痒、喷嚏"
                }
            ])
        
        elif severity in [Severity.MODERATE, Severity.SEVERE]:
            # 中-重度
            plan["primary_medications"].append({
                "name": "鼻用糖皮质激素（必需）",
                "options": ["糠酸莫米松", "丙酸氟替卡松", "布地奈德"],
                "dosage": "每天1-2次，每侧鼻孔2喷",
                "duration": "至少4周，症状控制后逐步减量"
            })
            
            # 鼻塞严重
            if symptoms.nasal_congestion >= 2:
                plan["primary_medications"].append({
                    "name": "鼻用减充血剂（短期）",
                    "drug": "羟甲唑啉",
                    "dosage": "每侧鼻孔1-2喷，每天2次",
                    "duration": "不超过3-5天",
                    "warning": "⚠️ 长期使用导致药物性鼻炎"
                })
            
            # 鼻痒明显
            if symptoms.nasal_itch >= 2:
                plan["primary_medications"].append({
                    "name": "口服抗组胺药",
                    "options": ["氯雷他定", "地氯雷他定", "左西替利嗪"],
                    "dosage": "每天1次"
                })
            
            # 合并哮喘
            if patient.has_asthma:
                plan["primary_medications"].append({
                    "name": "孟鲁司特钠",
                    "dosage": "10mg 每天1次（晚上）",
                    "reason": "同时管理上下气道炎症"
                })
                plan["warnings"].append(
                    "🚨 合并哮喘患者：鼻炎控制不佳可能诱发哮喘发作。"
                    "如出现喘息、呼吸困难，请立即就医！"
                )

        # 辅助治疗（适用所有人群）
        plan["adjunct_therapies"].append({
            "name": "生理盐水/海盐水鼻腔冲洗",
            "frequency": "每天2-3次",
            "benefit": "物理清除过敏原、稀释分泌物"
        })

        # 饮酒警告
        if patient.recent_alcohol:
            plan["warnings"].append(
                "⚠️ 近期饮酒：请避免使用西替利嗪等可能引起镇静的药物"
            )

        # 药物相互作用
        if "阿司匹林" in patient.current_medications or "氯吡格雷" in patient.current_medications:
            plan["warnings"].append(
                "⚠️ 您正在使用抗凝药物，长期使用鼻用激素可能增加鼻出血风险，请注意观察"
            )

        # 肾功能不全剂量调整
        if patient.has_kidney_disease and patient.creatinine_clearance:
            if patient.creatinine_clearance < 30:
                plan["special_instructions"].append(
                    "肾功能不全（肌酐清除率<30ml/min）：\n"
                    "- 西替利嗪：5mg 隔日1次\n"
                    "- 左西替利嗪：5mg 隔日1次\n"
                    "- 优先选择：鼻用激素（无需调整剂量）"
                )

        return plan

    @staticmethod
    def _pregnancy_plan(severity: Severity, patient: PatientInfo) -> Dict:
        """孕妇用药方案"""
        plan = {
            "primary_medications": [],
            "warnings": [
                "⚠️ 孕期用药需谨慎，以下方案相对安全，但仍建议产科医生评估"
            ],
            "special_instructions": [
                "孕早期（前3个月）：尽量避免用药，首选非药物治疗",
                "孕中晚期：可谨慎使用以下药物"
            ]
        }

        # 首选非药物治疗
        plan["primary_medications"].append({
            "name": "生理盐水鼻腔冲洗",
            "dosage": "每天3-4次",
            "priority": "首选",
            "safety": "完全安全"
        })

        if severity in [Severity.MODERATE, Severity.SEVERE]:
            plan["primary_medications"].extend([
                {
                    "name": "布地奈德鼻喷剂",
                    "dosage": "每天1次，每侧鼻孔1-2喷",
                    "safety": "FDA妊娠分级B级，相对安全"
                },
                {
                    "name": "氯雷他定",
                    "dosage": "10mg 每天1次",
                    "safety": "FDA妊娠分级B级",
                    "note": "症状明显时使用"
                }
            ])

        plan["contraindications"] = [
            "伪麻黄碱",
            "第一代抗组胺药",
            "长期大剂量鼻用减充血剂"
        ]

        return plan

    @staticmethod
    def _lactation_plan(severity: Severity, patient: PatientInfo) -> Dict:
        """哺乳期用药方案"""
        plan = {
            "primary_medications": [
                {
                    "name": "生理盐水鼻腔冲洗",
                    "dosage": "每天2-3次",
                    "safety": "完全安全"
                }
            ],
            "warnings": [
                "✅ 以下药物在哺乳期相对安全，乳汁中含量极低"
            ]
        }

        if severity in [Severity.MODERATE, Severity.SEVERE]:
            plan["primary_medications"].extend([
                {
                    "name": "布地奈德鼻喷剂",
                    "dosage": "每天1次，每侧鼻孔1-2喷",
                    "safety": "局部作用，极少进入乳汁"
                },
                {
                    "name": "氯雷他定",
                    "dosage": "10mg 每天1次",
                    "safety": "少量进入乳汁，但无明显影响"
                }
            ])

        return plan


class DangerSignalDetector:
    """危险信号检测器"""

    EMERGENCY_SIGNALS = {
        "asthma_attack": {
            "keywords": ["呼吸困难", "喘息", "胸闷", "无法平卧", "说话困难"],
            "action": "🚨 立即急诊！可能为哮喘发作，需紧急处理"
        },
        "anaphylaxis": {
            "keywords": ["全身皮疹", "面部肿胀", "喉头水肿", "血压下降", "意识改变"],
            "action": "🚨 立即急诊！可能为过敏性休克，需肾上腺素治疗"
        },
        "sinusitis_complication": {
            "keywords": ["高热不退", "剧烈头痛", "面部肿胀压痛", "视力改变"],
            "action": "🚨 立即就医！可能为鼻窦炎并发症"
        },
        "severe_epistaxis": {
            "keywords": ["鼻出血不止", "大量出血", "头晕", "心悸"],
            "action": "🚨 立即急诊止血"
        }
    }

    @staticmethod
    def check_danger_signals(user_input: str) -> List[Dict]:
        """
        检测用户输入中的危险信号
        
        Args:
            user_input: 用户输入文本
        
        Returns:
            检测到的危险信号列表
        """
        detected = []
        for signal_type, signal_info in DangerSignalDetector.EMERGENCY_SIGNALS.items():
            for keyword in signal_info["keywords"]:
                if keyword in user_input:
                    detected.append({
                        "type": signal_type,
                        "action": signal_info["action"]
                    })
                    break
        return detected


# 使用示例
if __name__ == "__main__":
    # 示例1：中度持续性过敏性鼻炎患者
    print("=" * 80)
    print("示例1：中度持续性过敏性鼻炎")
    print("=" * 80)
    
    symptoms = Symptoms(
        sneeze=2,  # 6-10个/天
        rhinorrhea=2,  # 6-10次擦拭/天
        nasal_itch=1,  # 偶尔痒
        nasal_congestion=2  # 白天也堵
    )
    
    tnss = symptoms.calculate_tnss()
    print(f"TNSS评分: {tnss}分")
    
    severity = ARDiagnostic.classify_severity(tnss)
    print(f"严重程度: {severity.value}")
    
    disease_course = DiseaseCourse(days_per_week=5, duration_weeks=6)
    pattern = ARDiagnostic.classify_pattern(disease_course)
    print(f"病程分型: {pattern.value}")
    
    patient = PatientInfo(
        age=35,
        has_asthma=True
    )
    
    plan = TreatmentPlanner.generate_treatment_plan(severity, pattern, patient, symptoms)
    
    print("\n治疗方案:")
    print("主要用药:")
    for med in plan["primary_medications"]:
        print(f"  • {med}")
    
    print("\n辅助治疗:")
    for adj in plan["adjunct_therapies"]:
        print(f"  • {adj}")
    
    if plan["warnings"]:
        print("\n⚠️  警告:")
        for warning in plan["warnings"]:
            print(f"  {warning}")
    
    # 示例2：孕妇患者
    print("\n" + "=" * 80)
    print("示例2：孕妇（中度）")
    print("=" * 80)
    
    pregnant_patient = PatientInfo(
        age=28,
        is_pregnant=True
    )
    
    pregnancy_plan = TreatmentPlanner.generate_treatment_plan(
        Severity.MODERATE,
        Pattern.PERSISTENT,
        pregnant_patient,
        symptoms
    )
    
    print("\n孕妇用药方案:")
    for med in pregnancy_plan["primary_medications"]:
        print(f"  • {med}")
    
    # 示例3：危险信号检测
    print("\n" + "=" * 80)
    print("示例3：危险信号检测")
    print("=" * 80)
    
    danger_input = "我现在呼吸困难，胸闷，喘不过气"
    signals = DangerSignalDetector.check_danger_signals(danger_input)
    
    if signals:
        print("⚠️  检测到危险信号:")
        for signal in signals:
            print(f"  {signal['action']}")
    else:
        print("✅ 未检测到危险信号")
